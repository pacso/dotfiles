class OhMyZsh < Dotfile
  GITHUB_CLONE_COMMAND = %Q{git clone https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"}
  ENABLE_ZSH_COMMAND = %Q{chsh -s `which zsh`}
  DISABLE_ZSH_COMMAND = %Q{chsh -s `which bash`}
  GITHUB_PULL_COMMAND = %Q{git pull}

  def self.install
    new.install
  end

  def self.enable
    new.enable
  end

  def self.disable
    new.disable
  end

  def self.update
    new.update
  end

  def install
    if already_installed?
      ConsoleNotifier.banner '~/.oh-my-zsh exists ... nothing to install'
    else
      ConsoleNotifier.banner 'Installing oh-my-zsh'
      system GITHUB_CLONE_COMMAND
      process_manifest
    end

    create_code_directory_if_required
  end

  def enable
    if already_installed?
      if zsh_enabled?
        ConsoleNotifier.banner 'Zsh is already the default shell'
      else
        ConsoleNotifier.banner 'Setting default shell to Zsh ...'
        system ENABLE_ZSH_COMMAND
      end

      create_code_directory_if_required
    else
      ConsoleNotifier.banner 'Cannot enable OhMyZsh ... install it first'
    end
  end

  def disable
    if zsh_enabled?
      ConsoleNotifier.banner 'Setting default shell to Bash ...'
      system DISABLE_ZSH_COMMAND
    else
      ConsoleNotifier.banner 'Zsh is already disabled'
    end
  end

  def update
    if already_installed?
      ConsoleNotifier.banner 'Updating oh-my-zsh'
      Dir.chdir(install_directory) { system GITHUB_PULL_COMMAND }
    else
      ConsoleNotifier.banner 'OhMyZsh must be installed first'
    end
  end

  def uninstall
    FileUtils.rm_r install_directory
  end

  private

  def create_code_directory_if_required
    Dir.mkdir code_directory unless code_directory_exists?
  end

  def code_directory_exists?
    File.exist?(code_directory)
  end

  def code_directory
    File.join(ENV['HOME'], 'code')
  end

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
