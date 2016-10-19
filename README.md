
[![Build Status](https://travis-ci.org/sul-dlss/app_version_tasks.svg?branch=master)](https://travis-ci.org/sul-dlss/app_version_tasks) [![Code Climate](https://codeclimate.com/github/sul-dlss/app_version_tasks/badges/gpa.svg)](https://codeclimate.com/github/sul-dlss/app_version_tasks) [![Test Coverage](https://codeclimate.com/github/sul-dlss/app_version_tasks/badges/coverage.svg)](https://codeclimate.com/github/sul-dlss/app_version_tasks/coverage) [![Issue Count](https://codeclimate.com/github/sul-dlss/app_version_tasks/badges/issue_count.svg)](https://codeclimate.com/github/sul-dlss/app_version_tasks) [![Inline docs](http://inch-ci.org/github/sul-dlss/app_version_tasks.svg?branch=master)](http://inch-ci.org/github/sul-dlss/app_version_tasks) [![Gem Version](https://badge.fury.io/rb/app_version_tasks.svg)](https://badge.fury.io/rb/app_version_tasks)

# AppVersionTasks

Rake tasks for application semantic version and release management.  Inspired by:

- https://github.com/nilbus/rails-app-versioning
- http://stackoverflow.com/questions/11199553/where-to-define-rails-apps-version-number

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'app_version_tasks'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install app_version_tasks

## Configuration

In the `Rakefile` for the project, load and configure with this snippet:

    spec = Gem::Specification.find_by_name 'app_version_tasks'
    load "#{spec.gem_dir}/lib/tasks/app_version_tasks.rake"

    require 'app_version_tasks'
    AppVersionTasks.configure do |config|
      # the following settings are the defaults
      config.application_name = Rails.application.class.parent_name
      config.version_file_path = File.join(Rails.root, 'config', 'version.rb')
      config.git_working_directory = Rails.root.to_s
    end

Each of the rake tasks that bump the semantic version will modify an
application version file; by default, the template for that file looks
like this:

    # Rails.root/config/version.rb
    module #{Rails.application.class.parent_name}
      class Application
        VERSION = '0.0.0'
      end
    end

If the version file does not exist, it will be created automatically from
that template.  If it exists already, it is assumed that it contains a
single quoted string matching the regex pattern: /'\d+\.\d+\.\d+'/

The default version_file_path is `Rails.root/config/version.rb`, but that can
be configured (see above).  When the default location is used, the version file
can be included in the `config/application.rb` using:

    # Rails.root/config/application.rb
    require_relative 'version'

If a different version file is used and it does not contain the structure above,
it might work with this gem.  The code in this gem simply assumes the version file
contains a semantic version surrounded by single quotes, e.g. `'x.y.z'`, where
the single quotes around the version string are an important assumption.

## Usage

`rake -T` should include these version tasks:

    version:bump:major - bump and commit the major version (x in x.0.0)
                       - resets the minor and patch versions to zero
                       - does not push the local workspace to 'origin'
    version:bump:minor - bump and commit the minor version (y in x.y.0)
                       - resets the patch version to zero
                       - does not push the local workspace to 'origin'
    version:bump:patch - bump and commit the patch version (z in x.y.z)
                       - does not push the local workspace to 'origin'
    version:current    - the current version
    version:release    - tag and push the current version
                       - pushes to 'origin/{current_branch}'

#### Report the current version

    bundle exec rake version:current

#### Bump and commit a patch version

    # Example: 0.0.0 moves to 0.0.1
    # Example: 1.1.1 moves to 1.1.2
    bundle exec rake version:bump:patch

#### Bump and commit a minor version

    # Example: 0.0.1 moves to 0.1.0
    # Example: 1.1.2 moves to 1.2.0
    bundle exec rake version:bump:minor

#### Bump and commit a major version

    # Example: 0.1.0 moves to 1.0.0
    # Example: 1.2.0 moves to 2.0.0
    bundle exec rake version:bump:major

#### Tag and push the current version

    # Example: tag 'v2.0.0' and push to origin
    bundle exec rake version:release

## Development

After checking out the repo, run `./bin/setup` to install dependencies. Then, run `rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/sul-dlss/app_version_tasks
