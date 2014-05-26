require 'spec_helper'

describe Dotfile do
  describe '#new' do
    it 'raises ArgumentError if filename not given' do
      expect { Dotfile.new }.to raise_exception ArgumentError
    end

    it 'raises ArgumentError if filename is empty' do
      expect { Dotfile.new '' }.to raise_exception ArgumentError
    end

    it 'raises ArgumentError if filename contains whitespace' do
      expect { Dotfile.new ' ' }.to raise_exception ArgumentError
    end
  end

  describe '#source_path' do
    it 'should append filename to the source base path' do
      d = Dotfile.new('filename')
      expect(d.source_path).to eq "#{SOURCE_BASE_PATH}/filename"
    end
  end

  describe '#target_path' do
    it 'should append target filename to the target base path' do
      d = Dotfile.new('filename')
      expect(d.target_path).to eq "#{TARGET_BASE_PATH}/.filename"
    end
  end

  describe '#target_filename' do
    it 'should prefix the filename with a dot' do
      d = Dotfile.new('filename')
      expect(d.target_filename).to eq '.filename'
    end

    it 'should strip .erb from source filename if present' do
      d = Dotfile.new('filename.erb')
      expect(d.target_filename).to eq '.filename'
    end
  end

  describe '#source_exists?' do
    it 'returns true when file exists' do
      d = Dotfile.new('new_file')
      expect(d.source_exists?).to be_true
    end

    it 'returns false when file missing' do
      d = Dotfile.new('missing')
      expect(d.source_exists?).to be_false
    end
  end

  describe '#destination_exists?' do
    it 'returns true when file exists' do
      d = Dotfile.new('existing_file')
      expect(d.target_exists?).to be_true
    end

    it 'returns false when missing' do
      d = Dotfile.new('non-existent_filename')
      expect(d.target_exists?).to be_false
    end
  end
end
