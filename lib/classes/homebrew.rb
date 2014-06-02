class Homebrew
  HOMEBREW_INSTALL_COMMAND = %q{ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"}
  HOMEBREW_DOCTOR_COMMAND = %q{brew doctor}

  def self.install
    h = self.new
    h.run_installer
  end

  def self.doctor
    h = self.new
    h.run_doctor
  end

  def run_installer
    if already_installed?
      ConsoleNotifier.banner 'Homebrew appears to already be installed. Skipping ...'
    else
      ConsoleNotifier.banner 'Installing Homebrew'
      system HOMEBREW_INSTALL_COMMAND
    end
  end

  def run_doctor
    system HOMEBREW_DOCTOR_COMMAND if already_installed?
  end

  def already_installed?
    File.exist?('/usr/local/bin/brew')
  end
end
