require 'aws_helpers/version'
require_relative '../lib/aws_helpers/cloud_formation/stack'
require_relative '../lib/aws_helpers/elastic_beanstalk/version'



module AwsHelpers
  extend self

  class << self

    def stack_provision(client, stack_name, template, options)
      CloudFormation::Stack.new(client, stack_name, template, options).provision
    end

    def beanstalk_version_deploy(application, environment, version, version_contents)
      ElasticBeanstalk::Version.new(application, environment, version, version_contents).deploy
    end

  end

end
