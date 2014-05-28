require 'rubygems'
require 'rake'

FIXTURE_SOURCE_PATH = File.join(File.dirname(__FILE__), 'fixture', 'sources')
FIXTURE_TARGET_PATH = File.join(File.dirname(__FILE__), 'fixture', 'target')
SPEC_TMP_DIR        = File.join(File.dirname(__FILE__), 'tmp')
SOURCE_BASE_PATH    = File.join(File.dirname(__FILE__), 'tmp', 'sources')
TARGET_BASE_PATH    = File.join(File.dirname(__FILE__), 'tmp', 'target')

require File.join(File.dirname(File.dirname(__FILE__)), 'lib', 'config', 'init')
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  config.order = 'random'

  config.before(:each) do
    Dir.mkdir SPEC_TMP_DIR
    FileUtils.copy_entry FIXTURE_SOURCE_PATH, SOURCE_BASE_PATH
    FileUtils.copy_entry FIXTURE_TARGET_PATH, TARGET_BASE_PATH
  end

  config.after(:each) do
    FileUtils.rm_r SPEC_TMP_DIR
  end
end
