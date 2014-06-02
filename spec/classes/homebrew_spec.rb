require 'spec_helper'

describe Homebrew do
  subject { Homebrew.new }

  before(:each) {
    File.stub(:exist?) { homebrew_installed? }
  }

  let(:homebrew_installed?) { false }

  describe '.install' do
    it 'calls the run_installer instance method' do
      expect_any_instance_of(Homebrew).to receive(:run_installer).once.with(no_args)
      Homebrew.install
    end
  end

  describe '.doctor' do
    it 'calls the run_doctor instance method' do
      expect_any_instance_of(Homebrew).to receive(:run_doctor).once.with(no_args)
      Homebrew.doctor
    end
  end

  context 'without homebrew already installed' do
    describe '#install' do
      it 'outputs an installation banner' do
        expect(ConsoleNotifier).to receive(:banner).with 'Installing Homebrew'
        subject.run_installer
      end

      it 'calls the installer' do
        expect_any_instance_of(Object).to receive(:system).once.with(%q{ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"})
        subject.run_installer
      end
    end

    describe '#doctor' do
      it 'does not call the system doctor command' do
        expect_any_instance_of(Object).not_to receive(:system)
        subject.run_doctor
      end
    end

    describe '#already_installed?' do
      it 'returns false' do
        expect(subject.already_installed?).to be_false
      end
    end
  end

  context 'with homebrew already installed' do
    let(:homebrew_installed?) { true }

    describe '#install' do
      it 'outputs a banner skipping installation' do
        expect(ConsoleNotifier).to receive(:banner).with 'Homebrew appears to already be installed. Skipping ...'
        subject.run_installer
      end

      it 'does not call the installer' do
        expect_any_instance_of(Object).not_to receive(:system)
        subject.run_installer
      end
    end

    describe '#doctor' do
      it 'calls the system doctor command' do
        expect_any_instance_of(Object).to receive(:system).once.with('brew doctor')
        subject.run_doctor
      end
    end

    describe '#already_installed?' do
      it 'returns true' do
        expect(subject.already_installed?).to be_true
      end
    end
  end
end
