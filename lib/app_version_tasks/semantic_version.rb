require 'git'
require_relative 'semantic_version_file'

module AppVersionTasks
  # Manage application semantic version
  class SemanticVersion
    # Semantic version attributes
    attr_reader :major, :minor, :patch

    def initialize
      @version_file = SemanticVersionFile.new
      @major, @minor, @patch = version_file.version_parts
    end

    # Bump semantic version category
    # @param [String|Symbol] category (:major, :minor, :patch)
    def bump(category)
      case category.to_sym
      when :major
        bump_major
      when :minor
        bump_minor
      when :patch
        bump_patch
      end
      bump_version
    end

    def release
      return 'Aborting - checkout correct branch and try again.' unless git_release_branch?
      git_release
    end

    def version
      [major, minor, patch].join('.')
    end

    private

    attr_accessor :version_file

    # Bump major version
    def bump_major
      @major += 1
      @minor = 0
      @patch = 0
    end

    # Bump minor version
    def bump_minor
      @minor += 1
      @patch = 0
    end

    # Bump patch version
    def bump_patch
      @patch += 1
    end

    # Save bumped version to file and commit
    def bump_version
      version_file.write(version)
      git_commit_version
    end

    def git
      @git ||= Git.open(AppVersionTasks.configuration.git_working_directory)
    end

    def git_commit_version
      version_file_path = version_file.path
      return unless git.diff(version_file_path).any?
      git.add(version_file_path)
      git.commit("Bump version: #{version}")
    end

    def git_current_branch
      git.lib.branch_current
    end

    def git_release_branch?
      current_branch = git_current_branch
      return true if current_branch == 'master'
      print "Working with current branch [#{current_branch}]. Continue? [y]: "
      response = $stdin.gets.chomp
      !response.match(/y/i).nil?
    end

    def git_release
      git_pull
      git_tag_version
      git_push
    end

    def git_pull
      current_branch = git_current_branch
      puts "Pulling from origin/#{current_branch}"
      puts git.pull('origin', current_branch)
    end

    def git_push
      current_branch = git_current_branch
      git.push('origin', current_branch)
      puts "Pushed to origin/#{current_branch}"
    end

    def git_tag_version
      git_commit_version
      tag_msg = "Release #{release_tag}"
      tag = git.add_tag(release_tag, a: true, m: tag_msg, f: true)
      puts "Added tag #{tag.name} on commit #{tag.sha}"
    end

    def release_tag
      "v#{version}"
    end
  end
end
