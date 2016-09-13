# -*- encoding: utf-8 -*-

require 'spec_helper'
require 'app_version_tasks/semantic_version_file'

describe AppVersionTasks::SemanticVersionFile do
  let(:version) { '0.0.1' }

  before do
    vf = described_class.new
    ver_file_path = vf.send(:path)
    FileUtils.rm(ver_file_path) if File.exist?(ver_file_path)
    expect(File.exist?(ver_file_path)).to be false
  end

  describe '#new' do
    it 'works' do
      expect(subject).to be_an described_class
    end

    it 'creates a version file when it is missing' do
      vf = described_class.new
      ver_file_path = vf.send(:path)
      expect(File.exist?(ver_file_path)).to be true
    end
  end

  describe '#read' do
    it 'works' do
      expect(subject).to receive(:path).at_least(:once).and_call_original
      result = subject.read
      expect(result).to be_an String
      expect(result).to match(/VERSION = '\d+\.\d+\.\d+'/)
    end
  end

  describe '#write' do
    it 'works' do
      expect(subject).to receive(:path).at_least(:once).and_call_original
      result = subject.write('0.0.2')
      expect(result).to be_an Integer
      result = subject.version_parts[2]
      expect(result).to eq(2)
    end
  end

  describe '#version' do
    it 'works' do
      result = subject.version
      expect(result).not_to be_nil
    end

    it 'can retry parsing version file and then raise exception' do
      expect(File).to receive(:read).exactly(3).and_return('')
      expect { subject.version }.to raise_error(RuntimeError)
    end
  end

  describe '#version_parts' do
    it 'returns an Array<Integer> with 3 numbers' do
      result = subject.version_parts
      expect(result).to be_an Array
      expect(result.first).to be_an Integer
      expect(result.length).to eq(3)
    end
  end
end
