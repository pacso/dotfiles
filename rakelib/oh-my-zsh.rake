require 'fileutils'

namespace 'oh-my-zsh' do
  task :disable do
    OhMyZsh.disable
  end

  task :enable do
    OhMyZsh.enable
  end

  task :install do
    OhMyZsh.install
    OhMyZsh.enable
  end

  task :update do
    OhMyZsh.update
  end

  task uninstall: [:disable] do
    OhMyZsh.uninstall
  end
end


