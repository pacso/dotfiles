require 'spec_helper'

shared_examples_for 'a manifestable object' do

  it_should_behave_like 'a decideable object' do
    let(:decideable) { manifestable }
  end

  before(:each) do
    unless respond_to? :manifestable
      raise "You must provide instance method manifestable"
    end
  end

  subject { manifestable }
  it { should respond_to :manifest }
  it { should respond_to :process_manifest }

  describe '#manifest' do
    before(:each) { allow(subject).to receive(:manifest_filename).and_return('dotfile.yml') }

    it 'returns a parsed hash of the manifest' do
      expect(subject.manifest).to eq( 'links' => %w(basedir/subdir/linkdir basedir/subdir/linkfile))
    end
  end

  describe '#process_manifest' do
    context 'no manifest exists' do
      before(:each) { allow(subject).to receive(:manifest_filename).and_return('unknown.yml') }

      it 'does nothing' do
        expect(subject).not_to receive(:link_files)
        expect(subject).not_to receive(:copy_files)
        subject.process_manifest
      end
    end

    context 'manifest exists' do
      context 'with links' do
        before(:each) { allow(subject).to receive(:manifest_filename).and_return('links.yml') }

        it 'calls #link_files' do
          expect(subject).to receive(:link_files)
          subject.process_manifest
        end
      end

      context 'with packages' do
        before(:each) { allow(subject).to receive(:manifest_filename).and_return('packages.yml') }

        it 'calls #install_missing_packages' do
          expect(subject).to receive(:install_missing_packages)
          subject.process_manifest
        end
      end

      context 'with empty links' do
        before(:each) { allow(subject).to receive(:manifest_filename).and_return('empty.yml') }

        it 'does not call #link_files' do
          expect(subject).not_to receive(:link_files)
          subject.process_manifest
        end
      end

      context 'with empty packages' do
        before(:each) { allow(subject).to receive(:manifest_filename).and_return('empty.yml') }

        it 'does not call #install_missing_packages' do
          expect(subject).not_to receive(:install_missing_packages)
          subject.process_manifest
        end
      end

      context 'without links' do
        before(:each) { allow(subject).to receive(:manifest_filename).and_return('packages.yml') }

        it 'does not call #link_files' do
          expect(subject).not_to receive(:link_files)
          subject.process_manifest
        end
      end

      context 'without packages' do
        before(:each) { allow(subject).to receive(:manifest_filename).and_return('links.yml') }

        it 'does not call #install_missing_packages' do
          expect(subject).not_to receive(:install_missing_packages)
          subject.process_manifest
        end
      end
    end
  end

  describe '#nested_file?(filename)' do
    it 'returns true if filename contains a slash' do
      expect(subject.nested_file?('some/file/with/path')).to be_truthy
    end

    it 'returns false if filename contains no slash' do
      expect(subject.nested_file?('somefile')).to be_falsey
    end
  end

  describe '#clear_obstructing_directories(filename)' do
    it 'states the directory being prepared, asks for permission, then removes the obstructions' do
      expect(ConsoleNotifier).to receive(:print).with "Preparing to create directory: #{TARGET_BASE_PATH}/.existing_directory/subdirectory_file"
      expect(subject).to receive(:ask).with("Remove #{TARGET_BASE_PATH}/.existing_directory/subdirectory_file?") { true }
      expect(subject).not_to receive(:ask)
      expect {
        subject.clear_obstructing_directories('existing_directory/subdirectory_file/invented_filename')
      }.to change {
        subject.parent_directories_obstructed?('existing_directory/subdirectory_file/invented_filename')
      }.from(true).to(false)
    end
  end

  describe '#parent_directories_obstructed?(filename)' do
    it 'returns false full directory path exists' do
      expect(subject.parent_directories_obstructed?('existing_directory/existing_subdirectory/invented_filename')).to be false
    end

    it 'returns false if none of the path exists' do
      expect(subject.parent_directories_obstructed?('completely/made/up/path')).to be false
    end

    it 'returns false if some of the path exists' do
      expect(subject.parent_directories_obstructed?('existing_directory/invented_filename')).to be false
    end

    it 'returns true if path contains a file' do
      expect(subject.parent_directories_obstructed?('existing_directory/subdirectory_file/invented_filename')).to be true
    end

    it 'returns true if path contains a symlink' do
      expect(subject.parent_directories_obstructed?('existing_symlink/invented_filename')).to be true
    end
  end

  describe '#link_files' do
    before(:each) { allow(subject).to receive(:manifest_filename).and_return('links.yml') }

    it 'creates parent directories and then links those files listed in the manifest' do
      subject.link_files
      expect(File.directory?(File.join(TARGET_BASE_PATH, '.basedir'))).to be true
      expect(File.directory?(File.join(TARGET_BASE_PATH, '.basedir', 'subdir'))).to be true

      expect(File.directory?(File.join(TARGET_BASE_PATH, '.basedir', 'subdir', 'linkdir'))).to be true
      expect(File.symlink?(File.join(TARGET_BASE_PATH, '.basedir', 'subdir', 'linkdir'))).to be true

      expect(File.file?(File.join(TARGET_BASE_PATH, '.basedir', 'subdir', 'linkfile'))).to be true
      expect(File.symlink?(File.join(TARGET_BASE_PATH, '.basedir', 'subdir', 'linkfile'))).to be true

      expect(File.file?(File.join(TARGET_BASE_PATH, '.basedir', 'subdir', 'linkdir', 'file'))).to be true
    end
  end

  describe '#install_missing_packages' do
    it 'should be provided by the including class' do
      expect(subject).to respond_to(:install_missing_packages)
    end
  end

  describe '#source_path(filename)' do
    it 'should append filename to the source base path' do
      expect(subject.source_path('filename')).to eq "#{SOURCE_BASE_PATH}/filename"
    end
  end

  describe '#target_path(filename)' do
    it 'should append target filename to the target base path' do
      expect(subject.target_path('filename')).to eq "#{TARGET_BASE_PATH}/.filename"
    end
  end

  describe '#target_filename(filename)' do
    it 'should prefix the filename with a dot' do
      expect(subject.target_filename('filename')).to eq '.filename'
    end

    it 'should strip .erb from source filename if present' do
      expect(subject.target_filename('filename.erb')).to eq '.filename'
    end
  end

  describe '#source_exists?(filename)' do
    it 'returns true when file exists' do
      expect(subject.source_exists?('new_file')).to be true
    end

    it 'returns false when file missing' do
      expect(subject.source_exists?('missing')).to be false
    end
  end

  describe '#target_exists?(filename)' do
    it 'returns true when file exists' do
      expect(subject.target_exists?('existing_file')).to be true
    end

    it 'returns false when missing' do
      expect(subject.target_exists?('non-existent_filename')).to be false
    end
  end

  describe '#target_identical?(filename)' do
    it 'returns true when target links to source' do
      expect(subject.target_identical?('existing_symlink')).to be true
    end

    it 'returns false if files are equal but not linked' do
      expect(subject.target_identical?('existing_file')).to be false
    end
  end

  describe '#create_symlink(filename)' do
    it 'creates a symlink in the target location to the source file' do
      expect { subject.create_symlink('new_file') }.to change { subject.target_identical?('new_file') }.from(false).to(true)
    end

    it 'raises exception if destination file already exists' do
      expect { subject.create_symlink('existing_symlink') }.to raise_error(Errno::EEXIST)
    end
  end

  describe '#remove_existing_target(filename)' do
    it 'deletes the file occupying the target path' do
      expect { subject.remove_existing_target('existing_file') }.to change { subject.target_exists?('existing_file') }.from(true).to(false)
    end

    it 'deletes the directory occupying the target path' do
      expect { subject.remove_existing_target('existing_directory') }.to change { subject.target_exists?('existing_directory') }.from(true).to(false)
    end

    it 'deletes the link occupying the target path' do
      expect { subject.remove_existing_target('existing_symlink') }.to change { subject.target_exists?('existing_symlink') }.from(true).to(false)
    end

    it 'force deletes files without write permission?' do
      pending 'need to decide if this is required'
      expect { subject.remove_existing_target('existing_file_without_write_permissions') }.to change { subject.target_exists?('existing_file_without_write_permissions') }.from(true).to(false)
    end

    it 'raises exception if destination file does not exist' do
      expect { subject.remove_existing_target('new_file') }.to raise_error(Errno::ENOENT)
    end
  end
end
