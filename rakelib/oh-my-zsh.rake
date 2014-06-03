require 'fileutils'

namespace 'oh-my-zsh' do
  desc 'Switch default shell back to Bash'
  task :disable do
    OhMyZsh.disable
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
    OhMyZsh.update
  end

  desc 'Completely remove oh-my-zsh'
  task uninstall: [:disable] do
    OhMyZsh.uninstall
  end
end


