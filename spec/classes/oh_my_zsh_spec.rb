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
    it 'calls the enable_zsh instance method' do
      expect_any_instance_of(OhMyZsh).to receive(:enable).once.with(no_args)
      OhMyZsh.enable
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
    end
  end
end
