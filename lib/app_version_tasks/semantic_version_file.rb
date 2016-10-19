
module AppVersionTasks
  # Manage application semantic version
  class SemanticVersionFile
    ##
    # A semantic version should match this pattern, i.e.
    # {major_digits}.{minor_digits}.{patch_digits}
    SEMVER_REGEX = /\d+\.\d+\.\d+/

    def initialize
      return if File.exist? path
      File.write(path, version_template)
      puts "AppVersionTasks: version file created: #{path}"
    end

    # @see AppVersionTasks.configuration.version_file_path
    # @return [String] path to version file
    def path
      AppVersionTasks.configuration.version_file_path
    end

    # Rewind and read version file
    # @return [String] content of version file
    def read
      File.read path
    end

    # Write semantic version to version file, by replacing an existing
    # 'x.y.z' in the version file with the 'i.j.k' in version parameter
    # @param [String] version - 'i.j.k'
    # @return [Integer] string length written to version file
    def write(version = '0.0.0')
      raise 'version must match a semantic version pattern' unless version =~ SEMVER_REGEX
      ver_data = read.gsub(SEMVER_REGEX, version)
      File.write(path, ver_data)
    end

    # @return [String] version in version file
    def version
      retries ||= 0
      read.match(SEMVER_REGEX)[0]
    rescue
      retry if (retries += 1) < 3
      raise 'failed to read and parse version file'
    end

    # @return [Array<Integer>] version components [major, minor, patch]
    def version_parts
      version.split('.').map(&:to_i)
    end

    private

      def version_template
        <<VERSION_TEMPLATE
module #{AppVersionTasks.configuration.application_name}
  class Application
    VERSION = '0.0.0'.freeze
  end
end
VERSION_TEMPLATE
      end
  end
end
