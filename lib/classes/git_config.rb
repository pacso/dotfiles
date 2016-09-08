class GitConfig

  DEFAULT_ALIASES = {
    checkout: 'co',
    branch: 'br',
    commit: 'ci',
    status: 'st'
  }

  def self.configure
    gc = self.new
    gc.configure
  end

  def configure
    set_name
    set_email
    set_aliases
  end

  def set_name
    update_global_config 'user.name', cli.ask("Name")
  end

  def set_email
    update_global_config 'user.email', cli.ask("Email")
  end

  def set_aliases
    if cli.agree 'Configure aliases?'
      DEFAULT_ALIASES.each do |command, default_alias|
        command_alias = cli.ask(command) { |q| q.default = default_alias }
        set_alias(command, command_alias)
      end
    end
  end

  def set_alias(command, command_alias)
    system("git config --global alias.#{command_alias} #{command}")
  end

  private

  def cli
    @cli ||= HighLine.new
  end

  def update_global_config(setting, value)
    system("git config --global #{setting} #{value}")
  end
end
