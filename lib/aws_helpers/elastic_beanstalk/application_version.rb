require_relative 'events'

module AwsHelpers
  module ElasticBeanstalk

    class ApplicationVersion

      def initialize(beanstalk)
        @beanstalk = beanstalk
        @events = Events.new(beanstalk)
      end

      def create(application, version_file)
        puts "Creating version #{version_file.version} for #{application}"
        @beanstalk.create_application_version(
          application_name: application,
          version_label: version_file.version,
          source_bundle: {
            s3_bucket: version_file.bucket,
            s3_key: version_file.file_name })
      end

      def deploy(application, environment, version)
        puts "Deploying version #{version} to #{application}, #{environment}"
        response = @beanstalk.update_environment(
          environment_name: environment,
          version_label: version)
        @events.pool(response[:date_updated], application, environment)
      end


    end
  end
end