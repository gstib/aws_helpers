module AwsHelpers
  module ElasticBeanstalk
    class Events

      def initialize(beanstalk)
        @beanstalk = beanstalk
      end

      def pool(start_time, application, environment)
        puts "Pooling events from #{start_time} for #{application}, #{environment}"
        loop do
          response = describe_version_events(start_time, application, environment)
          has_error = error?(response)
          has_success = success?(response)
          output_events(response) if has_success || has_error
          fail if has_error
          break if has_success
          sleep 10
        end
      end

      private

      def describe_version_events(start_time, application, environment)
        @beanstalk.describe_events(
          application_name: application,
          environment_name: environment,
          start_time: start_time
        )
      end

      def output_events(response)
        response[:events].sort_by { |e| e[:event_date] }.each do |event|
          print "TIME: #{event[:event_date]}, "
          print "TYPE: #{event[:severity]}, "
          puts "MESSAGE: #{event[:message]}"
        end
      end

      def error?(response)
        response[:events].find do |event|
          event[:severity] == 'ERROR'
        end
      end

      def success?(response)
        response[:events].find do |event|
          event[:severity] == 'INFO' &&
            event[:message] == 'Environment update completed successfully.'
        end
      end

    end
  end
end
