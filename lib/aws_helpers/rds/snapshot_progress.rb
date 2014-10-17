require_relative 'snapshot'

module AwsHelpers
  module RDS
    class SnapshotProgress

      def self.report(snapshot)

        loop do
          snapshot_details = snapshot.describe

          status = snapshot_details[:status]
          db_snapshot_identifier = snapshot_details[:db_snapshot_identifier]

          puts "Snapshot #{db_snapshot_identifier} #{status}"
          case status
            when SnapShotStatus::AVAILABLE
              break
            when SnapShotStatus::DELETING
              raise "Failed to create snapshot #{db_snapshot_identifier}"
            else
              sleep 30
          end
        end

      end
    end
  end
end
