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
      expect(subject.manifest).to eq( 'link' => %w(basedir/subdir/linkdir basedir/subdir/linkfile))
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

      context 'with empty links' do
        before(:each) { allow(subject).to receive(:manifest_filename).and_return('empty.yml') }

        it 'does not call #link_files' do
          expect(subject).not_to receive(:link_files)
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
    end
  end
end
