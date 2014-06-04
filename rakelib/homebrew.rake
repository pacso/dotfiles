namespace 'homebrew' do
  task :install do
    Homebrew.install
  end

  task :doctor do
    Homebrew.doctor
  end
end
