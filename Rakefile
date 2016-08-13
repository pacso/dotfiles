require File.join(File.dirname(__FILE__), 'lib', 'config', 'init')

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: [:spec]
rescue LoadError; end

desc 'Install everything'
task install: [:'oh-my-zsh:install']

namespace :install do
  desc 'Install oh-my-zsh'
  task 'oh-my-zsh' => [:'oh-my-zsh:install']

  desc 'Install Rvm'
  task rvm: [:'rvm:install']

  desc 'Install Homebew'
  task homebrew: [:'homebrew:install']
end

desc 'Remove everything'
task uninstall: [:'oh-my-zsh:uninstall']

desc 'Update everything'
task update: [:'update:self', :'oh-my-zsh:update']

namespace :update do
  desc 'Update dotfiles source'
  task :self do
    ConsoleNotifier.banner 'Updating .dotfiles project:'
    system %q{git pull}
  end

  desc 'Update oh-my-zsh'
  task 'oh-my-zsh' => [:'oh-my-zsh:update']
end
