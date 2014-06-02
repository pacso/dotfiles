namespace 'rvm' do
  desc 'Install rvm'
  task install: [:'homebrew:install', :'homebrew:doctor'] do
    Rvm.install
  end
end
