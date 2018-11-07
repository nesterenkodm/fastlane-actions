module Fastlane
  module Actions
    class GetXcodeBuildSettingAction < Action
        
      def self.run(params)
        xcode_project = params[:project]
        xcode_target = params[:target]
        xcode_configuration = params[:configuration]
        build_setting = params[:build_setting]

        UI.message("Getting #{build_setting} for #{xcode_target} target")

        targets = Xcodeproj::Project.open(xcode_project).targets
        target = targets.find { |target| target.name == xcode_target }
        
        if !target
            target_names = targets.map { |target| target.name }
            UI.user_error!("Target \"#{xcode_target}\" not found. Allowed targets are #{target_names}.")
        end
    
        if xcode_configuration.nil?
            result = target.common_resolved_build_setting(build_setting)
        else
            configuration = target.build_configuration_list[xcode_configuration]
            result = configuration.build_settings[build_setting]
        end
      end

      def self.description
        "Get Xcode Build Setting"
      end

      def self.authors
        ["Dmitry Nesterenko"]
      end

      def self.return_value
        result
      end

      def self.details
        # Optional:
        "Getting Xcode Build Setting"
      end

      def self.available_options
        [FastlaneCore::ConfigItem.new(key: :project,
                                       env_name: "FL_GET_XCODE_BUILD_SETTING_PROJECT",
                                       description: "The path to your project xcproj file",
                                       is_string: true,
                                       optional: false),
         FastlaneCore::ConfigItem.new(key: :target,
                                       env_name: "FL_GET_XCODE_BUILD_SETTING_TARGET",
                                       description: "Target name",
                                       is_string: true,
                                       optional: false),
         FastlaneCore::ConfigItem.new(key: :configuration,
                             env_name: "FL_GET_XCODE_BUILD_SETTING_CONFIGURATION",
                             description: "Configuration name",
                             is_string: true,
                             optional: true),
          FastlaneCore::ConfigItem.new(key: :build_setting,
                                       env_name: "FL_GET_XCODE_BUILD_SETTING_NAME",
                                       description: "Build setting name",
                                       is_string: true,
                                       optional: false)]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Platforms.md
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
