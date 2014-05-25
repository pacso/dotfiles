namespace 'rvm' do
  desc 'Install rvm'
  task install: [:'homebrew:install', :'homebrew:doctor'] do
    puts 'Installing RVM'
    system %q{ \curl -sSL https://get.rvm.io | bash -s stable --ruby }
  end
end
