require 'aws_helpers/version'
require_relative '../lib/aws_helpers/cloud_formation/stack'

module AwsHelpers
  extend self

  class << self
    def stack_provision(cloud_formation, stack_name, template, parameters = nil)
      Stack.new(cloud_formation, stack_name, template, parameters).provision
    end
  end

end
