namespace 'rvm' do
  task install: [:'homebrew:install', :'homebrew:doctor'] do
    Rvm.install
  end
end
