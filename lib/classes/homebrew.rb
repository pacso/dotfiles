class Homebrew
  include Manifestable

  HOMEBREW_INSTALL_COMMAND = %q{ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"}
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

    process_manifest
  end

  def install_default_packages
    DEFAULT_PACKAGES.each do |pkg|
      install_package pkg unless package_installed? pkg
    end
  end

  def run_doctor
    system HOMEBREW_DOCTOR_COMMAND unless not_installed?
  end

  def not_installed?
    !File.exist?('/usr/local/bin/brew')
  end

  private

  def install_package(pkg)
    system "brew install #{pkg}" if ask "brew install #{pkg}?"
  end

  def package_installed?(package)
    !installed_versions(package).empty?
  end

  def installed_versions(package)
    `brew ls --versions #{package}`
  end
end
