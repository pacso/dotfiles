require 'fileutils'

namespace 'oh-my-zsh' do
  desc 'Switch default shell back to Bash'
  task :disable do
    if !zsh_enabled?
      puts 'Zsh is already disabled'
    else
      puts 'Setting default shell to Bash ...'
      system %Q{ chsh -s `which bash` }
    end
  end

  desc 'Make Zsh the default shell'
  task :enable do
    OhMyZsh.enable
  end

  desc 'Install oh-my-zsh'
  task :install do
    OhMyZsh.install
    OhMyZsh.enable
  end

  desc 'Update oh-my-zsh'
  task :update do
    if zsh_installed?
      puts 'Updating oh-my-zsh:'
      Dir.chdir(zsh_directory) do
        system %Q{ git pull }
      end
    else
      puts 'ZSH must be installed first'
    end
  end

  desc 'Completely remove oh-my-zsh'
  task uninstall: [:disable] do
    FileUtils.rm_r zsh_directory
  end
end


