
namespace :version do
  desc 'report the current version'
  task :current do
    ver = AppVersionTasks::SemanticVersion.new
    puts ver.version
  end

  desc 'add and push a release tag for the current version'
  task :release do
    ver = AppVersionTasks::SemanticVersion.new
    puts ver.release
  end

  namespace :bump do
    desc 'bump and commit the major version (x.0.0)'
    task :major do
      ver = AppVersionTasks::SemanticVersion.new
      puts ver.bump(:major)
    end

    desc 'bump and commit the minor version (0.x.0)'
    task :minor do
      ver = AppVersionTasks::SemanticVersion.new
      puts ver.bump(:minor)
    end

    desc 'bump and commit the patch version (0.0.x)'
    task :patch do
      ver = AppVersionTasks::SemanticVersion.new
      puts ver.bump(:patch)
    end
  end
end
