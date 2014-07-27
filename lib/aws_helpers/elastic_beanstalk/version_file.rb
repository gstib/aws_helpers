module AwsHelpers
  module ElasticBeanstalk
    class VersionFile

      def initialize(application, version, contents)
        @application = application
        @version = version
        @contents = contents
      end

      def upload_to_s3
        puts "Uploading #{file_name} to S3 bucket #{bucket} "
        s3 = Aws::S3::Client.new
        s3.put_object(
          bucket: bucket,
          key: file_name,
          body: @contents
        )
      end

      def version
        @version
      end

      def file_name
        @file_name ||= "#{@application}-#{@version}.aws.json"
      end

      def bucket
        @bucket ||= query_bucket_name
      end

      def query_bucket_name
        iam = Aws::IAM::Client.new
        region = iam.config.region
        account = iam.get_user[:user][:arn][/::(.*):/, 1]
        "elasticbeanstalk-#{region}-#{account}"
      end

    end
  end
end