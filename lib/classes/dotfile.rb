class Dotfile
  SOURCE_BASE_PATH = File.dirname(File.dirname(File.dirname(__FILE__)))

  def initialize(filename = '')
    @filename = filename
  end

  def source_exists?
    File.exist? source_path
  end

  def source_path
    File.join SOURCE_BASE_PATH, @filename
  end
end
