module Fastlane
  module Actions
    class GetXcconfigSettingAction < Action
        
      def self.run(params)
        file = params[:file]
        attribute = params[:attribute]

        UI.message("Getting #{attribute} xcconfig attribute")

        if !File.exist? file
            UI.user_error!("File does not exists \"#{file}\".")
        end
        
        config = Xcodeproj::Config.new(file)
        result = config.attributes[attribute]
        
        if !result
            UI.user_error!("Attribute \"#{attribute}\" not found.")
        end
    
        return result
      end

      def self.description
        "Get Xcode Build Setting"
      end

      def self.authors
        ["Dmitry Nesterenko"]
      end

      def self.details
        # Optional:
        "Getting Xcode Config Setting"
      end

      def self.available_options
        [FastlaneCore::ConfigItem.new(key: :file,
                                      env_name: "FL_GET_XCCONFIG_SETTING_FILE",
                                      description: "The path to your project xcconfig file",
                                      is_string: true,
                                      optional: false),
         FastlaneCore::ConfigItem.new(key: :attribute,
                                      env_name: "FL_GET_XCCONFIG_SETTING_ATTRIBUTE",
                                      description: "Attribute name",
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
