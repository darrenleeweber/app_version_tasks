# -*- encoding: utf-8 -*-

require 'spec_helper'
require 'app_version_tasks/semantic_version'
require 'app_version_tasks/semantic_version_file'

describe AppVersionTasks::SemanticVersion do
  describe '#new' do
    it 'works' do
      expect(subject).to be_an described_class
    end
  end

  describe '#major' do
    it 'returns an Integer' do
      expect(subject.major).to be_an Integer
    end

    it 'defaults to zero' do
      expect(subject.major).to eq(0)
    end
  end

  describe '#minor' do
    it 'returns an Integer' do
      expect(subject.minor).to be_an Integer
    end

    it 'defaults to zero' do
      expect(subject.minor).to eq(0)
    end
  end

  describe '#patch' do
    it 'returns an Integer' do
      expect(subject.patch).to be_an Integer
    end

    it 'defaults to zero' do
      expect(subject.patch).to eq(0)
    end
  end

  describe '#bump' do
    before do
      expect(subject).to receive(:version_file).exactly(:twice).and_call_original
      expect(subject).to receive(:bump_version).and_call_original
    end

    it 'increments a major version, resets minor & patch versions' do
      category = 'major'
      expect(subject).to receive(:bump).with(category).and_call_original
      major1 = subject.major
      subject.bump(category)
      expect(subject.major).to eq(major1 + 1)
      expect(subject.minor).to eq(0)
      expect(subject.patch).to eq(0)
    end

    it 'increments a minor version, resets patch version' do
      category = 'minor'
      expect(subject).to receive(:bump).with(category).and_call_original
      major1 = subject.major
      minor1 = subject.minor
      subject.bump(category)
      expect(subject.major).to eq(major1)
      expect(subject.minor).to eq(minor1 + 1)
      expect(subject.patch).to eq(0)
    end

    it 'increments a patch version' do
      category = 'patch'
      expect(subject).to receive(:bump).with(category).and_call_original
      major1 = subject.major
      minor1 = subject.minor
      patch1 = subject.patch
      subject.bump(category)
      expect(subject.major).to eq(major1)
      expect(subject.minor).to eq(minor1)
      expect(subject.patch).to eq(patch1 + 1)
    end
  end

  describe '#release' do
    it 'confirms the release branch' do
      expect(subject).to receive(:git_release_branch?).and_return(true)
      expect(subject).to receive(:git_release).and_call_original
      git = subject.send(:git)
      expect(git).to receive(:pull).and_call_original
      expect(git).to receive(:push).and_call_original
      subject.release
    end

    it 'aborts for a non-release branch' do
      expect(subject).to receive(:git_release_branch?).and_return(false)
      expect(subject).not_to receive(:git_release)
      subject.release
    end
  end

  describe '#version' do
    it 'returns a String with a semantic version number' do
      expect(subject.version).to match(/\d+\.\d+\.\d+/)
    end
  end

  ##
  # PRIVATE

  describe '#git_release_branch?' do
    it 'accepts the "master" branch as a release branch' do
      expect(subject).to receive(:git_current_branch).and_return('master')
      expect(subject.send(:git_release_branch?)).to be true
    end

    it 'accepts user confirmation when the branch is not "master"' do
      expect(subject).to receive(:git_current_branch).and_return('develop')
      expect($stdin).to receive(:gets).and_return('y')
      expect(subject.send(:git_release_branch?)).to be true
    end

    it 'rejects the branch when user confirmation fails' do
      expect(subject).to receive(:git_current_branch).and_return('develop')
      expect($stdin).to receive(:gets).and_return('n')
      expect(subject.send(:git_release_branch?)).to be false
    end
  end
end
