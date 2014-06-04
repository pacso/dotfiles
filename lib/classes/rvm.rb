class Rvm
  include Decideable

  RVM_INSTALL_COMMAND = %q{\curl -sSL https://get.rvm.io | bash -s stable --ruby}

  def self.install
    new.install
  end

  def install
    if ask 'Run RVM Installer?'
      ConsoleNotifier.banner 'Installing RVM'
      system RVM_INSTALL_COMMAND
    end
  end
end
