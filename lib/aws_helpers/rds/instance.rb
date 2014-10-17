require 'aws-sdk-core'

require_relative 'snapshot'
require_relative 'snapshot_progress'

module AwsHelpers
  module RDS

    module InstanceState
      AVAILABLE = 'available'
      BACKING_UP = 'backing-up'
      MODIFYING = 'modifying'
      REBOOTING = 'rebooting'
    end

    class Instance

      def initialize(db_instance_id)
        @rds_client = Aws::RDS::Client.new
        @db_instance_id = db_instance_id
      end

      def snapshot
        poll_available
        snapshot = Snapshot.new(@rds_client, @db_instance_id)
        snapshot.create
        SnapshotProgress.report(snapshot)
      end

      private

      def poll_available

        loop do

          instance = @rds_client.describe_db_instances(db_instance_identifier: @db_instance_id)[:db_instances].first
          state = instance[:db_instance_status]
          puts "#{@db_instance_id} is #{state}"

          case state
            when InstanceState::AVAILABLE
              break
            when InstanceState::BACKING_UP, InstanceState::MODIFYING, InstanceState::REBOOTING
              sleep 30
            else
              raise "#{@db_instance_id} will never become #{InstanceState::AVAILABLE}"
          end

        end

      end

    end
  end
end

