require_relative 'stack_state'

module AwsHelpers
  class StackProgress

    def self.report(stack)

      loop do
        aws_stack = stack.aws_stack

        status = aws_stack[:stack_status]
        name = aws_stack[:stack_name]

        puts "Stack - #{name} status #{status}"

        case status
          when CREATE_COMPLETE, UPDATE_COMPLETE
            break
          when UPDATE_ROLLBACK_COMPLETE, ROLLBACK_FAILED, ROLLBACK_COMPLETE
            raise "Failed to update #{name}"
          else
            sleep 15
        end
      end

    end

  end
end