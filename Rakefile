desc 'Install everything'
task install: [:'oh-my-zsh:install']

desc 'Update everything'
task update: [:update_self, :'oh-my-zsh:update']

desc 'Remove everything'
task uninstall: [:'oh-my-zsh:uninstall']

task :update_self do
  puts 'Updating .dotfiles project:'
  system %Q{ git pull }
end
