class Homebrew
  include Decideable

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
    if not_installed?
      ConsoleNotifier.banner 'To continue you must install Homebrew'
      if ask 'Install Homebrew?'
        ConsoleNotifier.banner 'Installing Homebrew'
        system HOMEBREW_INSTALL_COMMAND
      end
    end
  end

  def run_doctor
    system HOMEBREW_DOCTOR_COMMAND unless not_installed?
  end

  def not_installed?
    !File.exist?('/usr/local/bin/brew')
  end
end
