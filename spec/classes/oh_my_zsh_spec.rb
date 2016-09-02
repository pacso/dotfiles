require 'spec_helper'

describe OhMyZsh do
  before(:each) {
    allow(File).to receive(:exist?) { oh_my_zsh_installed? }
    allow_any_instance_of(OhMyZsh).to receive(:zsh_enabled?) { zsh_enabled? }
    allow(Dir).to receive(:chdir).and_yield
  }

  let(:ohMyZsh) { OhMyZsh.new }
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
        ohMyZsh.install
      end

      it 'calls the github clone system command' do
        expect_any_instance_of(Object).to receive(:system).once.with(%q{git clone https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"})
        ohMyZsh.install
      end

      context 'without a code directory' do
        before(:each) do
          Dir.rmdir File.join(SPEC_TMP_DIR, 'code')
        end

        it 'outputs the directory creation banner' do
          expect(ConsoleNotifier).to receive(:banner).with 'Installing oh-my-zsh'
          expect(ConsoleNotifier).to receive(:banner).with "Creating missing directory: #{SPEC_TMP_DIR}/code"
          ohMyZsh.install
        end

        it 'creates the code directory' do
          expect(Dir.exists? File.join(SPEC_TMP_DIR, 'code')).to be false
          ohMyZsh.install
          expect(Dir.exists? File.join(SPEC_TMP_DIR, 'code')).to be true
        end
      end
    end

    describe '#enable' do
      it 'outputs a warning banner' do
        expect(ConsoleNotifier).to receive(:banner).with 'Cannot enable OhMyZsh ... install it first'
        ohMyZsh.enable
      end

      it 'does not call a system command' do
        expect_any_instance_of(Object).not_to receive(:system)
        ohMyZsh.enable
      end
    end

    describe '#update' do
      it 'outputs a warning banner' do
        expect(ConsoleNotifier).to receive(:banner).with 'OhMyZsh must be installed first'
        ohMyZsh.update
      end

      it 'does not call a system command' do
        expect_any_instance_of(Object).not_to receive(:system)
        ohMyZsh.update
      end
    end
  end

  context 'already installed' do
    let(:oh_my_zsh_installed?) { true }

    describe '#install' do
      it 'outputs an already installed banner' do
        expect(ConsoleNotifier).to receive(:banner).with '~/.oh-my-zsh exists ... nothing to install'
        ohMyZsh.install
      end

      it 'does not call a system command' do
        expect_any_instance_of(Object).not_to receive(:system)
        ohMyZsh.install
      end
    end

    describe '#enable' do
      it 'outputs an enabling banner' do
        expect(ConsoleNotifier).to receive(:banner).with 'Setting default shell to Zsh ...'
        ohMyZsh.enable
      end

      it 'calls the system command to enable zsh' do
        expect_any_instance_of(Object).to receive(:system).once.with(%Q{chsh -s `which zsh`})
        ohMyZsh.enable
      end
    end

    describe '#disable' do
      it 'outputs a warning banner' do
        expect(ConsoleNotifier).to receive(:banner).with 'Zsh is already disabled'
        ohMyZsh.disable
      end

      it 'does not call a system command' do
        expect_any_instance_of(Object).not_to receive(:system)
        ohMyZsh.disable
      end
    end

    describe '#update' do
      it 'outputs a notification banner' do
        expect(ConsoleNotifier).to receive(:banner).with 'Updating oh-my-zsh'
        ohMyZsh.update
      end

      it 'switches working directory' do
        expect(Dir).to receive(:chdir).once.with("#{ENV['HOME']}/.oh-my-zsh")
        ohMyZsh.update
      end

      it 'calls the update system command' do
        expect_any_instance_of(Object).to receive(:system).once.with('git pull')
        ohMyZsh.update
      end
    end

    context 'and enabled' do
      let(:zsh_enabled?) { true }

      describe '#enable' do
        it 'outputs a warning banner' do
          expect(ConsoleNotifier).to receive(:banner).with 'Zsh is already the default shell'
          ohMyZsh.enable
        end

        it 'does not call a system command' do
          expect_any_instance_of(Object).not_to receive(:system)
          ohMyZsh.enable
        end
      end

      describe '#disable' do
        it 'outputs a banner' do
          expect(ConsoleNotifier).to receive(:banner).with 'Setting default shell to Bash ...'
          ohMyZsh.disable
        end

        it 'calls a system command to switch default shells' do
          expect_any_instance_of(Object).to receive(:system).once.with(%Q{chsh -s `which bash`})
          ohMyZsh.disable
        end
      end
    end
  end
end
