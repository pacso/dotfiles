namespace 'rvm' do
  desc 'Install RVM'
  task install: [:'homebrew:install', :'homebrew:doctor'] do
    Rvm.install
  end
end
