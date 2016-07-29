module Fastlane
  module Actions
    class GetVersionCodeAction < Action
      def self.run(params)
        app_folder_name ||= params[:app_folder_name]
        UI.message("The get_version_code plugin is looking inside your project folder (#{app_folder_name})!")

        version_code = "0"

        Dir.glob("../**/#{app_folder_name}/build.gradle") do |path|
            begin
                file = File.new(path, "r")
                while (line = file.gets)
                    if line.include? "versionCode"
                       versionComponents = line.strip.split(' ')
                       version_code = versionComponents[1].tr("\"","")
                       break
                    end
                end
                file.close
            rescue => err
                UI.error("An exception occured while reading gradle file: #{err}")
                err
            end
        end

        if version_code == "0"
            UI.user_error!("Impossible to find the version code in the current project folder #{app_folder_name} 😭")
        else
            # Store the version name in the shared hash
            Actions.lane_context["VERSION_CODE"]=version_code
            UI.success("👍 Version name found: #{version_code}")
        end

        return version_code
      end

      def self.description
        "Get the version code of an Android project. This action will return the version code of your project according to the one set in your build.gradle file"
      end

      def self.authors
        ["Jérémy TOUDIC"]
      end

      def self.available_options
          [
            FastlaneCore::ConfigItem.new(key: :app_folder_name,
                                    env_name: "GETVERSIONCODE_APP_VERSION_NAME",
                                 description: "The name of the application source folder in the Android project (default: app)",
                                    optional: true,
                                        type: String,
                               default_value:"app")
          ]
        end

        def self.output
          [
            ['VERSION_CODE', 'The version code of the project']
          ]
        end

        def self.is_supported?(platform)
          [:android].include?(platform)
        end
    end
  end
end
