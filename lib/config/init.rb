require 'fileutils'

SOURCE_BASE_PATH  ||= File.join(File.dirname(File.dirname(File.dirname(__FILE__))), 'sources')
TARGET_BASE_PATH  ||= ENV['HOME']
MANIFESTS_PATH    ||= File.join(File.dirname(File.dirname(__FILE__)), 'manifests')

%w{modules classes}.each do |dir|
  Dir[[Dir[File.expand_path('../..', __FILE__)], dir, '*.rb'].join('/')].each { |f| require f }
end
