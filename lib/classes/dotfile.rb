class Dotfile
  def initialize(filename)
    @filename = filename.strip
    raise ArgumentError, 'Filename must not be blank' if @filename == ''
  end

  def source_exists?
    @filename != '' && File.exist?(source_path)
  end

  def target_exists?
    @filename != '' && File.exist?(target_path)
  end

  def source_path
    File.join SOURCE_BASE_PATH, @filename
  end

  def target_path
    File.join TARGET_BASE_PATH, target_filename
  end

  def target_filename
    '.' + @filename.sub(/\.erb$/, '')
  end
end
