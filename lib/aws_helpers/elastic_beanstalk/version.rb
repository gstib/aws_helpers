require 'aws-sdk-core'
require_relative 'version_file'
require_relative 'application_version'

module AwsHelpers
  module ElasticBeanstalk
    class Version

      def initialize(application, environment, version, version_contents)

        raise_argument_error 'application' if application.nil?
        raise_argument_error 'environment' if environment.nil?
        raise_argument_error 'version' if version.nil?
        raise_argument_error 'version_contents' if version_contents.nil?

        @application = application
        @environment = environment
        @version = version

        @version_file = VersionFile.new(@application, @version, version_contents)
        @application_version = ApplicationVersion.new(Aws::ElasticBeanstalk::Client.new)
      end

      def deploy
        @version_file.upload_to_s3
        @application_version.create(@application, @version_file)
        @application_version.deploy(@application, @environment, @version)
      end

      private

      def raise_argument_error(argument)
        fail ArgumentError, "#{argument} is not set"
      end

    end
  end
end