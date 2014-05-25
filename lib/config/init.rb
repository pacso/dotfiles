require 'fileutils'

SOURCE_BASE_PATH      ||= File.dirname(File.dirname(File.dirname(__FILE__)))
DESTINATION_BASE_PATH ||= ENV['HOME']

%w{ classes }.each do |dir|
  Dir[[Dir[File.expand_path('../..', __FILE__)], dir, '*.rb'].join('/')].each { |f| require f }
end
