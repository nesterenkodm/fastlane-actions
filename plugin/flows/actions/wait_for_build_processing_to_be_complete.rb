module Fastlane
  module Actions
    class WaitForBuildProcessingToBeCompleteAction < Action
      def self.run(values)
        require "pilot"
        require "pilot/options"
        
        return values if Helper.test?
        
        app_version = values[:app_version]
        app_build = values[:app_build]

        while true do
          # login
          manager = Pilot::BuildManager.new
          manager.start(values)
          
          # wait processing to complete
          # reconnect on connection error
          begin
            FastlaneCore::BuildWatcher.wait_for_build_processing_to_be_complete(app_id: manager.app.apple_id, platform: manager.fetch_app_platform, train_version: app_version, build_version: app_build, poll_interval: values[:wait_processing_interval], strict_build_watch: true)
            break
          rescue \
            Spaceship::UnauthorizedAccessError,
            Spaceship::UnexpectedResponse,
            Faraday::SSLError,
            OpenSSL::SSL::SSLError,
            Faraday::ConnectionFailed => e
              # pass
              UI.error e
          end
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Waits for a build processing to be complete"
      end

      def self.available_options
        require "pilot"
        require "pilot/options"
        pilot_options = FastlaneCore::CommanderGenerator.new.generate(Pilot::Options.available_options)
        pilot_options.select {|x|
            [:wait_processing_interval,
             :app_identifier,
             :username,
             :team_id,
             :apple_id,
             :app_platform,
             :ipa,
             :team_name].include? x.key
        } + [
           FastlaneCore::ConfigItem.new(key: :app_version,
                                   env_name: "WAIT_FOR_UPLOADED_BUILD_TO_BE_COMPLETE_APP_VERSION",
                                description: "App version",
                                   optional: false,
                                       type: String),
           FastlaneCore::ConfigItem.new(key: :app_build,
                                   env_name: "WAIT_FOR_UPLOADED_BUILD_TO_BE_COMPLETE_APP_BUILD",
                                description: "App build",
                                   optional: false,
                                       type: String),
        ]
      end

      def self.category
        :beta
      end

      def self.authors
        ["chebur.mail@gmail.com"]
      end

      def self.is_supported?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
