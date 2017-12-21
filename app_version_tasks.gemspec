lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'app_version_tasks/version'

Gem::Specification.new do |spec|
  spec.name          = 'app_version_tasks'
  spec.version       = AppVersionTasks::VERSION
  spec.authors       = ['Darren L. Weber, Ph.D.']
  spec.email         = ['dweber.consulting@gmail.com']

  spec.summary       = 'Application version tasks.'
  spec.description   = 'Rake tasks to manage application semantic version.'
  spec.homepage      = 'https://github.com/darrenleeweber/app_version_tasks'

  spec.files = `git ls-files -z`.split("\x0").reject do |file|
    file.match(/^(bin|config.ru|Gemfile.lock|spec)/)
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'git', '~> 1.3'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'yard'

  spec.add_development_dependency 'combustion', '~> 0.7.0'
  spec.add_development_dependency 'rails', '~> 4.2'
  spec.add_development_dependency 'rspec-rails', '~> 3.4', '>= 3.4.2'
  spec.add_development_dependency 'sqlite3'

  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'single_cov', '~> 0.5'
end
