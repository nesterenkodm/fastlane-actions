module Fastlane
  module Actions
    class TelegramAction < Action
        
      def self.run(params)
        UI.message("Posting message to a telegram channel")
        
        token = params[:token]
        chat_id = params[:chat_id]
        text = params[:text]
        
        options = {:chat_id => chat_id, :text => text}
        if params[:parse_mode]
            options[:parse_mode] = params[:parse_mode]
        end

        uri = URI.parse("https://api.telegram.org/bot#{token}/sendMessage")
        response = Net::HTTP.post_form(uri, options)
      end

      def self.description
        "Telegram Build Bot"
      end

      def self.authors
        ["chebur"]
      end

      def self.return_value
        response
      end

      def self.details
        # Optional:
        "Posts new message to a telegram channel"
      end

      def self.available_options
        [
           FastlaneCore::ConfigItem.new(key: :token,
                                   env_name: "TELEGRAM_TOKEN",
                                description: "A unique authentication token given when a bot is created",
                                   optional: false,
                                       type: String),
           FastlaneCore::ConfigItem.new(key: :chat_id,
                                   env_name: "TELEGRAM_CHAT_ID",
                                description: "Unique identifier for the target chat or username of the target channel (in the format @channelusername)",
                                   optional: false,
                                       type: String),
           FastlaneCore::ConfigItem.new(key: :text,
                                   env_name: "TELEGRAM_TEXT",
                                description: "Text of the message to be sent",
                                   optional: false,
                                       type: String),
           FastlaneCore::ConfigItem.new(key: :parse_mode,
                                   env_name: "TELEGRAM_PARSE_MODE",
                                description: "Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in your bot's message",
                                   optional: true)
        ]
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
