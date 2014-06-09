class Dotfile
  include Decideable

  def manifest
    @manifest ||= YAML.load(File.read(File.join(MANIFESTS_PATH, manifest_filename)))
  end

  def manifest_filename
    "#{basename}.yml"
  end

  def basename
    underscore(self.class.name)
  end

  def underscore(word)
    w = word.dup
    w.gsub!(/::/, '/')
    w.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    w.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    w.tr!("-", "_")
    w.downcase!
    w
  end

  def process_manifest
    link_files
    copy_files
  end

  def link_files
    manifest['link'].each do |filename|
      create_parent_directories_if_missing(target_path(filename))
      create_symlink(filename)
    end
  end

  def create_parent_directories_if_missing(filename)
    if filename =~ /\//
      FileUtils.mkdir_p File.dirname(filename)
    end
  end

  def copy_files
    true
  end

  def source_exists?(filename)
    filename != '' && File.exist?(source_path filename)
  end

  def target_exists?(filename)
    filename != '' && File.exist?(target_path filename)
  end

  def target_identical?(filename)
    File.identical? target_path(filename), source_path(filename)
  end

  def source_path(filename)
    File.join SOURCE_BASE_PATH, filename
  end

  def target_path(filename)
    File.join TARGET_BASE_PATH, target_filename(filename)
  end

  def target_filename(filename)
    '.' + filename.sub(/\.erb$/, '')
  end

  def create_symlink(filename)
    File.symlink source_path(filename), target_path(filename)
  end

  def remove_existing_target(filename)
    case File.ftype(target_path(filename))
      when 'file'
        File.delete target_path(filename)
      when 'directory'
        FileUtils.rm_r target_path(filename)
      when 'link'
        File.unlink target_path(filename)
      else
        raise NotImplementedError,
          "Cannot remove file of type '#{File.ftype(target_path(filename))}'"
    end
  end
end
