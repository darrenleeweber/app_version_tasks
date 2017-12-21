require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

require 'app_version_tasks'
AppVersionTasks.configure do |config|
  config.application_name = 'AppVersionTasks'
  config.version_file_path = File.join('lib', 'app_version_tasks', 'version.rb')
end

Dir.glob('lib/tasks/*.rake').each { |r| load r }

RSpec::Core::RakeTask.new(:spec)
task default: :spec
