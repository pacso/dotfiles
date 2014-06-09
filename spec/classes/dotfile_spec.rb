require 'spec_helper'

describe Dotfile do
  it_should_behave_like 'a decideable object' do
    let(:decideable) { Dotfile.new }
  end

  let(:dotfile) { Dotfile.new }

  before(:each) { dotfile.stub(:ask).and_return(true) }

  describe '#process_manifest' do
    context 'no manifest exists' do
      before(:each) { dotfile.stub(:manifest_filename).and_return('unknown.yml') }

      it 'does nothing' do
        expect(dotfile).not_to receive(:link_files)
        expect(dotfile).not_to receive(:copy_files)
        dotfile.process_manifest
      end
    end

    context 'manifest exists' do
      it 'calls #link_files' do
        expect(dotfile).to receive(:link_files)
        dotfile.process_manifest
      end

      it 'calls #copy_files' do
        expect(dotfile).to receive(:copy_files)
        dotfile.process_manifest
      end
    end
  end

  describe '#nested_file?(filename)' do
    it 'returns true if filename contains a slash' do
      expect(dotfile.nested_file?('some/file/with/path')).to be_true
    end

    it 'returns false if filename contains no slash' do
      expect(dotfile.nested_file?('somefile')).to be_false
    end
  end

  describe '#clear_obstructing_directories(filename)' do
    it 'states the directory being prepared, asks for permission, then removes the obstructions' do
      expect(ConsoleNotifier).to receive(:print).with "Preparing to create directory: #{TARGET_BASE_PATH}/.existing_directory/subdirectory_file"
      expect(dotfile).to receive(:ask).with "Remove #{TARGET_BASE_PATH}/.existing_directory/subdirectory_file?"
      expect(dotfile).not_to receive(:ask)
      expect {dotfile.clear_obstructing_directories('existing_directory/subdirectory_file/invented_filename')}.to change { dotfile.parent_directories_obstructed?('existing_directory/subdirectory_file/invented_filename')}.from(true).to(false)
    end
  end

  describe '#parent_directories_obstructed?(filename)' do
    it 'returns false full directory path exists' do
      expect(dotfile.parent_directories_obstructed?('existing_directory/existing_subdirectory/invented_filename')).to be_false
    end

    it 'returns false if none of the path exists' do
      expect(dotfile.parent_directories_obstructed?('completely/made/up/path')).to be_false
    end

    it 'returns false if some of the path exists' do
      expect(dotfile.parent_directories_obstructed?('existing_directory/invented_filename')).to be_false
    end

    it 'returns true if path contains a file' do
      expect(dotfile.parent_directories_obstructed?('existing_directory/subdirectory_file/invented_filename')).to be_true
    end

    it 'returns true if path contains a symlink' do
      expect(dotfile.parent_directories_obstructed?('existing_symlink/invented_filename')).to be_true
    end
  end

  # describe '#parent_directories_missing?(filename)' do
  #   it 'returns true if full path does not exist' do
  #
  #   end
  # end

  describe '#link_files' do
    it 'creates parent directories and then links those files listed in the manifest' do
      dotfile.link_files
      expect(File.directory?(File.join(TARGET_BASE_PATH, '.basedir'))).to be_true
      expect(File.directory?(File.join(TARGET_BASE_PATH, '.basedir', 'subdir'))).to be_true

      expect(File.directory?(File.join(TARGET_BASE_PATH, '.basedir', 'subdir', 'linkdir'))).to be_true
      expect(File.symlink?(File.join(TARGET_BASE_PATH, '.basedir', 'subdir', 'linkdir'))).to be_true

      expect(File.file?(File.join(TARGET_BASE_PATH, '.basedir', 'subdir', 'linkfile'))).to be_true
      expect(File.symlink?(File.join(TARGET_BASE_PATH, '.basedir', 'subdir', 'linkfile'))).to be_true

      expect(File.file?(File.join(TARGET_BASE_PATH, '.basedir', 'subdir', 'linkdir', 'file'))).to be_true
    end
  end

  describe '#manifest' do
    it 'returns a parsed hash of the oh-my-zsh.yml manifest' do
      expect(dotfile.manifest).to eq( 'link' => %w(basedir/subdir/linkdir basedir/subdir/linkfile))
    end
  end

  describe '#source_path(filename)' do
    it 'should append filename to the source base path' do
      expect(dotfile.source_path('filename')).to eq "#{SOURCE_BASE_PATH}/filename"
    end
  end

  describe '#target_path(filename)' do
    it 'should append target filename to the target base path' do
      expect(dotfile.target_path('filename')).to eq "#{TARGET_BASE_PATH}/.filename"
    end
  end

  describe '#target_filename(filename)' do
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

  describe '#target_exists?(filename)' do
    it 'returns true when file exists' do
      expect(dotfile.target_exists?('existing_file')).to be_true
    end

    it 'returns false when missing' do
      expect(dotfile.target_exists?('non-existent_filename')).to be_false
    end
  end

  describe '#target_identical?(filename)' do
    it 'returns true when target links to source' do
      expect(dotfile.target_identical?('existing_symlink')).to be_true
    end

    it 'returns false if files are equal but not linked' do
      expect(dotfile.target_identical?('existing_file')).to be_false
    end
  end

  describe '#create_symlink(filename)' do
    it 'creates a symlink in the target location to the source file' do
      expect { dotfile.create_symlink('new_file') }.to change { dotfile.target_identical?('new_file') }.from(false).to(true)
    end

    it 'raises exception if destination file already exists' do
      expect { dotfile.create_symlink('existing_symlink') }.to raise_exception
    end
  end

  describe '#remove_existing_target(filename)' do
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
