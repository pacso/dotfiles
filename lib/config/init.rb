require 'fileutils'
require 'yaml'

APP_ROOT ||= File.dirname(File.dirname(File.dirname(__FILE__)))
SOURCE_BASE_PATH ||= File.join(APP_ROOT, 'sources')
TARGET_BASE_PATH  ||= ENV['HOME']
MANIFESTS_PATH ||= File.join(APP_ROOT, 'lib', 'manifests')

%w{decideable}.each do |module_file|
  require File.join(APP_ROOT, 'lib', 'modules', "#{module_file}.rb")
end

%w{console_notifier dotfile homebrew oh_my_zsh rvm}.each do |class_file|
  require File.join(APP_ROOT, 'lib', 'classes', "#{class_file}.rb")
end
