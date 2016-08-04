require 'spec_helper'

describe Homebrew do
  before(:each) {
    allow(File).to receive(:exist?) { homebrew_installed? }
  }

  it_should_behave_like 'a decideable object' do
    let(:decideable) { Homebrew.new }
  end

  let(:homebrew) { Homebrew.new }
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

  context 'not installed' do
    before(:each) { allow_any_instance_of(Homebrew).to receive(:ask) { true } }

    describe '#install' do
      it 'outputs an installation banner' do
        expect(ConsoleNotifier).to receive(:banner).with 'To continue you must install Homebrew'
        expect(ConsoleNotifier).to receive(:banner).with 'Installing Homebrew'
        homebrew.run_installer
      end

      it 'calls the installer' do
        expect_any_instance_of(Object).to receive(:system).once.with(%q{ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"})
        homebrew.run_installer
      end
    end

    describe '#doctor' do
      it 'does not call the system doctor command' do
        expect_any_instance_of(Object).not_to receive(:system)
        homebrew.run_doctor
      end
    end

    describe '#not_installed?' do
      it 'returns true' do
        expect(homebrew.not_installed?).to be true
      end
    end
  end

  context 'with homebrew already installed' do
    let(:homebrew_installed?) { true }
    before(:each) { allow_any_instance_of(Homebrew).to receive(:ask) { true } }

    describe '#install' do
      it 'does not output a banner' do
        expect(ConsoleNotifier).not_to receive(:banner)
        homebrew.run_installer
      end

      it 'does not call the installer' do
        expect_any_instance_of(Object).not_to receive(:system)
        homebrew.run_installer
      end
    end

    describe '#doctor' do
      it 'calls the system doctor command' do
        expect_any_instance_of(Object).to receive(:system).once.with('brew doctor')
        homebrew.run_doctor
      end
    end

    describe '#not_installed?' do
      it 'returns false' do
        expect(homebrew.not_installed?).to be false
      end
    end
  end
end
