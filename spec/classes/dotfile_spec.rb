require 'spec_helper'

describe Dotfile do
  it_should_behave_like 'a decideable object' do
    let(:decideable) { Dotfile.new }
  end

  let(:dotfile) { Dotfile.new }

  describe '#source_path' do
    it 'should append filename to the source base path' do
      expect(dotfile.source_path('filename')).to eq "#{SOURCE_BASE_PATH}/filename"
    end
  end

  describe '#target_path' do
    it 'should append target filename to the target base path' do
      expect(dotfile.target_path('filename')).to eq "#{TARGET_BASE_PATH}/.filename"
    end
  end

  describe '#target_filename' do
    it 'should prefix the filename with a dot' do
      expect(dotfile.target_filename('filename')).to eq '.filename'
    end

    it 'should strip .erb from source filename if present' do
      expect(dotfile.target_filename('filename.erb')).to eq '.filename'
    end
  end

  describe '#source_exists?(filename)' do
    it 'returns true when file exists' do
      expect(dotfile.source_exists?('new_file')).to be_true
    end

    it 'returns false when file missing' do
      expect(dotfile.source_exists?('missing')).to be_false
    end
  end

  describe '#target_exists?' do
    it 'returns true when file exists' do
      expect(dotfile.target_exists?('existing_file')).to be_true
    end

    it 'returns false when missing' do
      expect(dotfile.target_exists?('non-existent_filename')).to be_false
    end
  end

  describe '#target_identical?' do
    it 'returns true when target links to source' do
      expect(dotfile.target_identical?('existing_symlink')).to be_true
    end

    it 'returns false if files are equal but not linked' do
      expect(dotfile.target_identical?('existing_file')).to be_false
    end
  end

  describe '#create_symlink' do
    it 'creates a symlink in the target location to the source file' do
      expect { dotfile.create_symlink('new_file') }.to change { dotfile.target_identical?('new_file') }.from(false).to(true)
    end

    it 'raises exception if destination file already exists' do
      expect { dotfile.create_symlink('existing_symlink') }.to raise_exception
    end
  end

  describe '#remove_existing_target' do
    it 'deletes the file occupying the target path' do
      expect { dotfile.remove_existing_target('existing_file') }.to change { dotfile.target_exists?('existing_file') }.from(true).to(false)
    end

    it 'deletes the directory occupying the target path' do
      expect { dotfile.remove_existing_target('existing_directory') }.to change { dotfile.target_exists?('existing_directory') }.from(true).to(false)
    end

    it 'deletes the link occupying the target path' do
      expect { dotfile.remove_existing_target('existing_symlink') }.to change { dotfile.target_exists?('existing_symlink') }.from(true).to(false)
    end

    it 'force deletes files without write permission?' do
      pending 'need to decide if this is required' do
        expect { dotfile.remove_existing_target('existing_file_without_write_permissions') }.to change { dotfile.target_exists?('existing_file_without_write_permissions') }.from(true).to(false)
      end
    end

    it 'raises exception if destination file does not exist' do
      expect { dotfile.remove_existing_target('new_file') }.to raise_exception
    end
  end
end
