
namespace :version do
  desc 'add and push a release tag for the current version'
  task release: :environment do
    ver = AppVersionTasks::SemanticVersion.new
    puts ver.release
  end

  namespace :bump do
    desc 'bump and push the major version (x.0.0)'
    task major: :environment do
      ver = AppVersionTasks::SemanticVersion.new
      puts ver.bump(:major)
    end

    desc 'bump and push the minor version (0.x.0)'
    task minor: :environment do
      ver = AppVersionTasks::SemanticVersion.new
      puts ver.bump(:minor)
    end

    desc 'bump and push the patch version (0.0.x)'
    task patch: :environment do
      ver = AppVersionTasks::SemanticVersion.new
      puts ver.bump(:patch)
    end
  end
end
