namespace 'homebrew' do
  desc 'Install Homebrew'
  task :install do
    Homebrew.install
  end

  task :doctor do
    Homebrew.doctor
  end
end
