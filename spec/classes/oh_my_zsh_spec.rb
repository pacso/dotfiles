require 'spec_helper'

describe OhMyZsh do
  subject { OhMyZsh.new }

  before(:each) {
    File.stub(:exist?) { oh_my_zsh_installed? }
    OhMyZsh.any_instance.stub(:zsh_enabled?) { zsh_enabled? }
  }

  let(:oh_my_zsh_installed?) { false }
  let(:zsh_enabled?) { false }

  describe '.install' do
    it 'calls the install instance method' do
      expect_any_instance_of(OhMyZsh).to receive(:install).once.with(no_args)
      OhMyZsh.install
    end
  end

  describe '.enable_zsh' do
    it 'calls the enable instance method' do
      expect_any_instance_of(OhMyZsh).to receive(:enable).once.with(no_args)
      OhMyZsh.enable
    end
  end

  describe '.disable' do
    it 'calls the disable instance method' do
      expect_any_instance_of(OhMyZsh).to receive(:disable).once.with(no_args)
      OhMyZsh.disable
    end
  end

  describe '.update' do
    it 'calls the update instance method' do
      expect_any_instance_of(OhMyZsh).to receive(:update).once.with(no_args)
      OhMyZsh.update
    end
  end

  context 'not installed' do
    describe '#install' do
      it 'outputs an installation banner' do
        expect(ConsoleNotifier).to receive(:banner).with 'Installing oh-my-zsh'
        subject.install
      end

      it 'calls the github clone system command' do
        expect_any_instance_of(Object).to receive(:system).once.with(%q{git clone https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"})
        subject.install
      end
    end

    describe '#enable' do
      it 'outputs a warning banner' do
        expect(ConsoleNotifier).to receive(:banner).with 'Cannot enable OhMyZsh ... install it first'
        subject.enable
      end

      it 'does not call a system command' do
        expect_any_instance_of(Object).not_to receive(:system)
        subject.enable
      end
    end

    describe '#update' do
      it 'outputs a warning banner' do
        expect(ConsoleNotifier).to receive(:banner).with 'OhMyZsh must be installed first'
        subject.update
      end

      it 'does not call a system command' do
        expect_any_instance_of(Object).not_to receive(:system)
        subject.update
      end
    end
  end

  context 'already installed' do
    let(:oh_my_zsh_installed?) { true }

    describe '#install' do
      it 'outputs an already installed banner' do
        expect(ConsoleNotifier).to receive(:banner).with '~/.oh-my-zsh exists ... nothing to install'
        subject.install
      end

      it 'does not call a system command' do
        expect_any_instance_of(Object).not_to receive(:system)
        subject.install
      end
    end

    describe '#enable' do
      it 'outputs an enabling banner' do
        expect(ConsoleNotifier).to receive(:banner).with 'Setting default shell to Zsh ...'
        subject.enable
      end

      it 'calls the system command to enable zsh' do
        expect_any_instance_of(Object).to receive(:system).once.with(%Q{chsh -s `which zsh`})
        subject.enable
      end
    end

    describe '#disable' do
      it 'outputs a warning banner' do
        expect(ConsoleNotifier).to receive(:banner).with 'Zsh is already disabled'
        subject.disable
      end

      it 'does not call a system command' do
        expect_any_instance_of(Object).not_to receive(:system)
        subject.disable
      end
    end

    describe '#update' do
      it 'outputs a notification banner' do
        expect(ConsoleNotifier).to receive(:banner).with 'Updating oh-my-zsh'
        subject.update
      end

      it 'switches working directory' do
        expect(Dir).to receive(:chdir).once.with("#{ENV['HOME']}/.oh-my-zsh")
        subject.update
      end

      it 'calls the update system command' do
        expect_any_instance_of(Object).to receive(:system).once.with('git pull')
        subject.update
      end
    end

    context 'and enabled' do
      let(:zsh_enabled?) { true }

      describe '#enable' do
        it 'outputs a warning banner' do
          expect(ConsoleNotifier).to receive(:banner).with 'Zsh is already the default shell'
          subject.enable
        end

        it 'does not call a system command' do
          expect_any_instance_of(Object).not_to receive(:system)
          subject.enable
        end
      end

      describe '#disable' do
        it 'outputs a banner' do
          expect(ConsoleNotifier).to receive(:banner).with 'Setting default shell to Bash ...'
          subject.disable
        end

        it 'calls a system command to switch default shells' do
          expect_any_instance_of(Object).to receive(:system).once.with(%Q{chsh -s `which bash`})
          subject.disable
        end
      end
    end
  end
end
