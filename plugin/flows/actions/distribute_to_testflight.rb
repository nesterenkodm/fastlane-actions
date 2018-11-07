module Fastlane
  module Actions
    class DistributeToTestflightAction < Action
      def self.run(values)
        require "pilot"
        require "pilot/options"

        changelog = Actions.lane_context[SharedValues::FL_CHANGELOG]
        values[:changelog] ||= changelog if changelog

        return values if Helper.test?
        
        app_version = values[:app_version]
        app_build = values[:app_build]
        
        manager = Pilot::BuildManager.new
        manager.start(values)
        
        UI.message("Sending \"#{manager.app.name}\" #{app_version} (#{app_build}) to testers...")
        
        builds = Spaceship::TestFlight::Build.builds_for_train(app_id: manager.app.apple_id, platform: manager.fetch_app_platform, train_version: app_version, retry_count: 2)
        build = builds.find { |build| build.build_version == app_build }
        UI.user_error!("Build #{app_version} - #{app_build} not found in Testflight. Please upload it to TestFlight before distributing.") unless build

        manager.distribute(values, build: build)
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Distributes a build for TestFlight beta testing (via _pilot_)"
      end

      def self.available_options
        require "pilot"
        require "pilot/options"
        FastlaneCore::CommanderGenerator.new.generate(Pilot::Options.available_options) + [
           FastlaneCore::ConfigItem.new(key: :app_version,
                                   env_name: "DISTRIBUTE_TO_TESTFLIGHT_APP_VERSION",
                                description: "App version",
                                   optional: false,
                                       type: String),
           FastlaneCore::ConfigItem.new(key: :app_build,
                                   env_name: "DISTRIBUTE_TO_TESTFLIGHT_APP_BUILD",
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
