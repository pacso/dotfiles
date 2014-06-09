class Dotfile
  include Decideable

  def manifest
    @manifest ||= YAML.load(File.read(manifest_file)) if File.exist?(manifest_file)
  end

  def manifest_file
    File.join(MANIFESTS_PATH, manifest_filename)
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
    if manifest
      link_files
      copy_files
    end
  end

  def link_files
    manifest['link'].each do |filename|
      prepare_nest(filename) if nested_file?(filename)
      create_symlink(filename)
    end
  end

  def nested_file?(filename)
    filename =~ /\//
  end

  def prepare_nest(filename)
    clear_obstructing_directories(filename) if parent_directories_obstructed?(filename)
    create_parent_directories(filename) unless File.directory?(File.dirname(target_path filename))
  end

  def clear_obstructing_directories(filename)
    ConsoleNotifier.print("Preparing to create directory: #{File.dirname target_path(filename)}")
    for_obstructions_in_target_path(filename) { |t| remove_existing_target t }
  end

  def parent_directories_obstructed?(filename)
    obstructed = false
    for_obstructions_in_target_path(filename) { obstructed = true }
    obstructed
  end

  def for_obstructions_in_target_path(filename)
    target = filename.dup
    while target != ''
      if File.exist?(target_path target) && !File.directory?(target_path target)
        yield target
      end
      if target =~ /\//
        target.gsub!(/\/[^\/]*$/, '')
      else
        target = ''
      end
    end
  end

  def create_parent_directories(filename)
    FileUtils.mkdir_p File.dirname(target_path filename)
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
    ConsoleNotifier.print "Creating symlink: #{target_path filename} --> #{source_path filename}"
    File.symlink source_path(filename), target_path(filename)
  end

  def remove_existing_target(filename)
    if ask "Remove #{target_path(filename)}?"
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
end
