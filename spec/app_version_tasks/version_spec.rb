# -*- encoding: utf-8 -*-

require 'spec_helper'
require 'app_version_tasks/version'

describe AppVersionTasks do
  it 'has a VERSION constant' do
    expect(AppVersionTasks::VERSION).not_to be nil
  end

  it 'has a semantic version number' do
    expect(AppVersionTasks::VERSION).to match(/\d+\.\d+\.\d+/)
  end
end
