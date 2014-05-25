require File.expand_path('../lib/config/init', __FILE__)

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError; end

desc 'Install everything'
task install: [:'oh-my-zsh:install']

desc 'Update everything'
task update: [:update_self, :'oh-my-zsh:update']

desc 'Remove everything'
task uninstall: [:'oh-my-zsh:uninstall']

desc 'Update dotfiles source'
task :update_self do
  puts 'Updating .dotfiles project:'
  system %Q{ git pull }
end

