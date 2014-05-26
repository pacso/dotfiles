require 'rubygems'
require 'rake'

SOURCE_BASE_PATH      = File.join(File.dirname(__FILE__), 'fixture', 'sources')
TARGET_BASE_PATH = File.join(File.dirname(__FILE__), 'fixture', 'target')

require File.join(File.dirname(File.dirname(__FILE__)), 'lib', 'config', 'init')

RSpec.configure do |config|
  config.order = 'random'
end
