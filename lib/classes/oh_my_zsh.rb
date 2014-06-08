require 'yaml'

class OhMyZsh
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
      install_files
    end
  end

  def install_files
    link_files
  end

  def link_files
    files_to_link.each do |f|
      create_parent_directories_if_missing(target_filename f)
      File.symlink(source_filename(f), target_filename(f))
    end
  end

  def create_parent_directories_if_missing(filename)
    if filename =~ /\//
      FileUtils.mkdir_p File.dirname(filename)
    end
  end

  def source_filename(filename)
    File.join(SOURCE_BASE_PATH, filename)
  end

  def target_filename(filename)
    File.join(TARGET_BASE_PATH, ".#{filename}")
  end

  def files_to_link
    manifest['link']
  end

  def manifest
    @manifest ||= YAML.load(File.read(File.join(MANIFESTS_PATH, manifest_filename)))
  end

  def manifest_filename
    'oh-my-zsh.yml'
  end

  def basename
    File.basename(__FILE__, File.extname(__FILE__))
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
