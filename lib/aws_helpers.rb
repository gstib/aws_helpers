require 'aws_helpers/version'
require_relative '../lib/aws_helpers/cloud_formation/stack'
require_relative '../lib/aws_helpers/elastic_beanstalk/version'



module AwsHelpers
  extend self

  class << self

    def stack_provision(client, stack_name, template, options)
      CloudFormation::Stack.new(client, stack_name, template, options).provision
    end

    def stack_outputs(client, stack_name)
      CloudFormation::Stack.outputs(client, stack_name)
    end

    def beanstalk_version_deploy(application, environment, version, version_contents, zip_folder)
      ElasticBeanstalk::Version.new(application, environment, version, version_contents, zip_folder).deploy
    end

  end

end
