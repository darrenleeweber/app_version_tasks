module AppVersionTasks
  ##
  # Configuration parameters
  class Configuration
    attr_reader :application_name
    attr_reader :version_file_path
    attr_reader :git_working_directory

    def initialize(opts = {})
      self.application_name = opts[:application_name]
      self.git_working_directory = opts[:git_working_directory]
      self.version_file_path = opts[:version_file_path]
    end

    # @param [String] application_name
    def application_name=(value)
      @application_name = begin
        value || Rails.application.class.parent_name
      rescue StandardError
        'App'
      end
    end

    # @param [String] value for the git working directory
    def git_working_directory=(value)
      @git_working_directory = value || default_root_path
    end

    # @param [String] value for the version file path
    def version_file_path=(value)
      @version_file_path = value || default_version_path
    end

    private

      # @return [String] path
      def default_root_path
        Rails.root.to_s
      rescue StandardError
        Dir.pwd
      end

      # @return [String] path
      def default_version_path
        File.join(default_root_path, 'config', 'version.rb')
      end
  end
end
