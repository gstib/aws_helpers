require 'aws_helpers/version'
require_relative '../lib/aws_helpers/cloud_formation/stack'
require_relative '../lib/aws_helpers/elastic_beanstalk/version'

module AwsHelpers
  extend self

  class << self

    def stack_provision(stack_name, template, options)
      CloudFormation::Stack.new(stack_name, template, options).provision
    end

    def stack_s3_provision(stack_name, template, bucket_name, options)
      CloudFormation::Stack.new(stack_name, template, options.merge(bucket_name: bucket_name)).provision
    end

    def stack_outputs(stack_name)
      CloudFormation::Stack.outputs(stack_name)
    end

    def stack_exists?(stack_name)
      CloudFormation::Stack.exists?(stack_name)
    end

    def beanstalk_deploy(application, environment, version)
      ElasticBeanstalk::Version.new.deploy(application, environment, version)
    end

    def beanstalk_upload(application, version, version_contents, zip_folder)
      ElasticBeanstalk::Version.new.upload(application, version, version_contents, zip_folder)
    end

  end
end
