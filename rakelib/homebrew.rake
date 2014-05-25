namespace 'homebrew' do
  task :install do
    if File.exist?('/usr/local/bin/brew')
      puts 'Homebrew appears to already be installed. Skipping ...'
    else
      puts 'Installing Homebrew'
      system %q{ ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)" }
    end
  end

  task :doctor do
    system %q{ brew doctor }
  end
end
