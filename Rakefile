require File.join(File.dirname(__FILE__), 'lib', 'config', 'init')

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: [:spec]
rescue LoadError; end

desc 'Install everything'
task install: [:'oh-my-zsh:install']

desc 'Update everything'
task update: [:update_self, :'oh-my-zsh:update']

desc 'Remove everything'
task uninstall: [:'oh-my-zsh:uninstall']

desc 'Ask'
task :ask do
  if decision.ask('Output bananas?')
    puts 'B-A-N-A-N-A-S!'
  else
    puts 'boring!'
  end
end

desc 'Update dotfiles source'
task :update_self do
  puts 'Updating .dotfiles project:'
  system %Q{ git pull }
end

