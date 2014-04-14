require_relative 'stack_state'
require_relative 'stack_progress'
require 'aws-sdk-core'

module AwsHelpers
  class Stack

    def initialize(cloud_formation, stack_name, template, parameters)
      @cloud_formation = cloud_formation
      @stack_name = stack_name
      @template = template
      @parameters = parameters || []
    end

    def provision

      if create_rollback?
        delete
      end
      exists? ? update : create

    end

    def aws_stack
      @cloud_formation.describe_stacks(stack_name: @stack_name)[:stacks].first
    end

    private

    def exists?
      begin
        !@cloud_formation.describe_stacks(stack_name: @stack_name)[:stacks].first.nil?
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

      @cloud_formation.create_stack(
          stack_name: @stack_name,
          template_body: @template,
          parameters: @parameters
      )

      until aws_stack
        sleep 5
      end

      StackProgress.report(self)
    end

    def update
      puts "Updating #{@stack_name}"

      begin
        @cloud_formation.update_stack(
            stack_name: @stack_name,
            template_body: @template,
            parameters: @parameters
        )
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

      @cloud_formation.delete_stack(
          stack_name: @stack_name
      )

      while exists?
        sleep 5
      end

    end

  end
end