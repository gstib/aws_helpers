require_relative 'stack_state'
require_relative 'stack_progress'
require 'aws-sdk-core'

module AwsHelpers
  module CloudFormation

    class Stack

      def initialize(client, stack_name, template, options = {})
        @client = client
        @stack_name = stack_name
        @template = template
        @parameters = options[:parameters]
        @capabilities = options[:capabilities]
      end

      def provision

        if create_rollback?
          delete
        end
        exists? ? update : create
        outputs
      end

      def outputs
        aws_stack[:outputs].map { |output| output.to_h }
      end

      def aws_stack
        @client.describe_stacks(stack_name: @stack_name)[:stacks].first
      end

      private

      def exists?
        begin
          !@client.describe_stacks(stack_name: @stack_name)[:stacks].first.nil?
        rescue Aws::CloudFormation::Errors::ValidationError => validation_error
          if validation_error.message == "Stack:#{@stack_name} does not exist"
            false
          else
            raise validation_error
          end
        end
      end

      def status
        aws_stack[:stack_status] if exists?
      end

      def create_rollback?
        aws_stack[:stack_status] == ROLLBACK_COMPLETE if exists?
      end

      def create
        puts "Creating #{@stack_name}"
        @client.create_stack(create_request)

        until aws_stack
          sleep 5
        end

        StackProgress.report(self)
      end

      def update
        puts "Updating #{@stack_name}"
        begin
          @client.update_stack(create_request)
          StackProgress.report(self)
        rescue Aws::CloudFormation::Errors::ValidationError => validation_error
          if validation_error.message == 'No updates are to be performed.'
            puts "No updates to perform for #{@stack_name}."
          else
            raise validation_error
          end
        end

      end

      def delete
        puts "Deleting #{@stack_name}"

        @client.delete_stack(
          stack_name: @stack_name
        )

        while exists?
          sleep 5
        end

      end

      def create_request
        request = {
          stack_name: @stack_name,
          template_body: @template
        }
        request.merge!(parameters: @parameters) if @parameters
        request.merge!(capabilities: @capabilities) if @capabilities
        request
      end


    end

  end
end