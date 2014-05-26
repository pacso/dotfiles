require 'spec_helper'

describe Dotfile do
  describe '#new' do
    it 'raises ArgumentError if filename not given' do
      expect { Dotfile.new }.to raise_exception ArgumentError
    end

    it 'raises ArgumentError if filename is empty' do
      expect { Dotfile.new '' }.to raise_exception ArgumentError
    end

    it 'raises ArgumentError if filename contains only whitespace' do
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

  describe '#target_exists?' do
    it 'returns true when file exists' do
      d = Dotfile.new('existing_file')
      expect(d.target_exists?).to be_true
    end

    it 'returns false when missing' do
      d = Dotfile.new('non-existent_filename')
      expect(d.target_exists?).to be_false
    end
  end

  describe '#target_identical?' do
    it 'returns true when target links to source' do
      d = Dotfile.new('existing_symlink')
      expect(d.target_identical?).to be_true
    end

    it 'returns false if files are equal but not linked' do
      d = Dotfile.new('existing_file')
      expect(d.target_identical?).to be_false
    end
  end

  describe '#create_symlink' do
    it 'creates a symlink in the target location to the source file' do
      d = Dotfile.new('new_file')
      expect { d.create_symlink! }.to change { d.target_identical? }.from(false).to(true)
    end

    it 'raises exception if destination file already exists' do
      d = Dotfile.new('existing_symlink')
      expect { d.create_symlink! }.to raise_exception
    end
  end
end
