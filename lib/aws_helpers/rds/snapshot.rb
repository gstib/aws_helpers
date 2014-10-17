module AwsHelpers
  module RDS

    module SnapShotStatus
      CREATING='creating'
      AVAILABLE='available'
      DELETING = 'deleting'
    end

    class Snapshot

      def initialize(rds_client, db_instance_id)
        @rds_client = rds_client
        @db_instance_id = db_instance_id
        @snapshot_id = nil
      end

      def create
        iam = Aws::IAM::Client.new
        region = iam.config.region
        account = iam.get_user[:user][:arn][/::(.*):/, 1]

        tags = @rds_client.list_tags_for_resource(resource_name:"arn:aws:rds:#{region}:#{account}:db:#{@db_instance_id}")
        name_tag = tags[:tag_list].detect{|tag| tag[:key] == 'Name'}

        if name_tag

          formatted_datetime = DateTime.now.strftime('%Y%m%d%H%M%S')
          snapshot_name = "#{name_tag[:value]}-#{formatted_datetime}"

          snapshot = @rds_client.create_db_snapshot(
              db_instance_identifier: @db_instance_id,
              db_snapshot_identifier: snapshot_name,
              tags: [key: 'Name', value: snapshot_name]
          )
          @snapshot_id = snapshot[:db_snapshot][:db_snapshot_identifier]

        end

      end

      def describe
          @rds_client.describe_db_snapshots(db_snapshot_identifier: @snapshot_id)[:db_snapshots].first
      end

    end
  end
end
