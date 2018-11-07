module Fastlane
  module Actions
    class GitCommitsScanAction < Action
      def self.run(values)
        between = values[:between]
        pattern = values[:pattern]
        
        string = other_action.changelog_from_git_commits(between: between, quiet: true)
        return [] if string.nil?

        results = string.split("\n").reduce([]) do |issues, comment|
            matches = comment.scan(pattern)
            if matches.count > 0
                issues.push(matches)
            end
            issues
        end

        results.uniq.sort
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Lists tasks that was found in git comments between specified tags"
      end

      def self.available_options
        [
           FastlaneCore::ConfigItem.new(key: :between,
                                        env_name: "GIT_COMMITS_SCAN_BETWEEN",
                                        description: "Array containing two Git revision values between which to collect messages, you mustn\'t use it with :commits_count key at the  same time",
                                        optional: true,
                                        is_string: false,
                                        verify_block: proc do |value|
                                          if value.kind_of?(String)
                                            UI.user_error!(":between must contain comma") unless value.include?(',')
                                          else
                                            UI.user_error!(":between must be of type array") unless value.kind_of?(Array)
                                            UI.user_error!(":between must not contain nil values") if value.any?(&:nil?)
                                            UI.user_error!(":between must be an array of size 2") unless (value || []).size == 2
                                          end
                                        end),
           FastlaneCore::ConfigItem.new(key: :pattern,
                                   env_name: "GIT_COMMITS_SCAN_PATTERN",
                               description: "Scan pattern to look for issue identifiers",
                                   optional: false,
                                       type: Regexp),
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
