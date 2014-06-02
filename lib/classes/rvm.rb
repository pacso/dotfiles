class Rvm
  RVM_INSTALL_COMMAND = %q{\curl -sSL https://get.rvm.io | bash -s stable --ruby}

  def self.install
    rvm = self.new
    rvm.install
  end

  def install
    ConsoleNotifier.banner 'Installing RVM'
    system RVM_INSTALL_COMMAND
  end
end
