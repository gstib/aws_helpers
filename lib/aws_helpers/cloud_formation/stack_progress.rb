require_relative 'stack_state'

module AwsHelpers
  module CloudFormation
    class StackProgress

      def self.report(stack)

        loop do
          aws_stack = stack.describe_stack

          status = aws_stack[:stack_status]
          name = aws_stack[:stack_name]

          puts "Stack - #{name} status #{status}"

          case status
            when CREATE_COMPLETE, UPDATE_COMPLETE
              break
            when UPDATE_ROLLBACK_COMPLETE, ROLLBACK_FAILED, ROLLBACK_COMPLETE
              raise "Failed to provision #{name}"
            else
              sleep 30
          end
        end

      end
    end
  end
end