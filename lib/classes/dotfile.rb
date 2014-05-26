class Dotfile
  def initialize(filename = '')
    @filename = filename
  end

  def source_exists?
    @filename != '' && File.exist?(source_path)
  end

  def destination_exists?
    @filename != '' && File.exist?(destination_path)
  end

  private
  def source_path
    File.join SOURCE_BASE_PATH, @filename
  end

  def destination_path
    File.join DESTINATION_BASE_PATH, ".#{@filename}"
  end
end
