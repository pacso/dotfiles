require 'fileutils'

namespace 'oh-my-zsh' do
  desc 'Switch default shell back to Bash'
  task :disable do
    if !zsh_enabled?
      puts 'ZSH is already disabled'
    else
      puts 'Setting default shell to Bash ...'
      system %Q{ chsh -s `which bash` }
    end
  end

  desc 'Make ZSH the default shell'
  task :enable do
    if  !zsh_installed?
      puts 'ZSH must be installed first'
    elsif zsh_enabled?
      puts 'ZSH is already the default shell'
    else
      puts 'Setting default shell to ZSH ...'
      system %Q{ chsh -s `which zsh` }
    end
  end

  desc 'Install ZSH'
  task :install do
    if zsh_installed?
      puts '~/.oh-my-zsh exists ... nothing to install'
    else
      puts 'Installing ZSH ...'
      system %Q{ git clone https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh" }
    end
    Rake::Task['oh-my-zsh:enable'].invoke
  end

  desc 'Update ZSH'
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

def zsh_installed?
  File.exist?(zsh_directory)
end

def zsh_directory
  File.join(ENV['HOME'], '.oh-my-zsh')
end

def zsh_enabled?
  ENV['SHELL'] =~ /zsh/
end
