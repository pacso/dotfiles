class OhMyZsh
  GITHUB_CLONE_COMMAND = %Q{git clone https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"}
  ENABLE_ZSH_COMMAND = %Q{chsh -s `which zsh`}

  def self.install
    new.install
  end

  def self.enable
    new.enable
  end

  def install
    if already_installed?
      ConsoleNotifier.banner '~/.oh-my-zsh exists ... nothing to install'
    else
      ConsoleNotifier.banner 'Installing oh-my-zsh'
      system GITHUB_CLONE_COMMAND
    end
  end

  def enable
    if already_installed?
      if zsh_enabled?
        ConsoleNotifier.banner 'Zsh is already the default shell'
      else
        ConsoleNotifier.banner 'Setting default shell to Zsh ...'
        system ENABLE_ZSH_COMMAND
      end
    else
      ConsoleNotifier.banner 'Cannot enable OhMyZsh ... install it first'
    end
  end

  private

  def already_installed?
    File.exist?(install_directory)
  end

  def install_directory
    File.join(ENV['HOME'], '.oh-my-zsh')
  end

  def zsh_enabled?
    ENV['SHELL'] =~ /zsh/
  end
end
