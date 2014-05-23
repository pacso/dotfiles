namespace 'zsh' do
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
  end

  desc 'Update ZSH'
  task :update do
    if zsh_installed?
      Dir.chdir(zsh_directory) do
        system %Q{ git pull }
      end
    else
      puts 'ZSH must be installed first'
    end
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