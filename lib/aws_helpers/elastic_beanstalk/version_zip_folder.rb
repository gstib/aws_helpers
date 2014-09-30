module AwsHelpers
  module ElasticBeanstalk
    class VersionZipFolder < VersionFile
      def file_name
        @file_name ||= "#{@application}-#{@version}.zip"
      end
    end
  end
end