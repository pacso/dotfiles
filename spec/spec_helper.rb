require 'rubygems'
require 'rake'
require 'climate_control'

FIXTURE_SOURCE_PATH = File.join(File.dirname(__FILE__), 'fixture', 'sources')
FIXTURE_TARGET_PATH = File.join(File.dirname(__FILE__), 'fixture', 'target')
SPEC_TMP_DIR        = File.join(File.dirname(__FILE__), 'tmp')
SOURCE_BASE_PATH    = File.join(File.dirname(__FILE__), 'tmp', 'sources')
TARGET_BASE_PATH    = File.join(File.dirname(__FILE__), 'tmp', 'target')
MANIFESTS_PATH      = File.join(File.dirname(__FILE__), 'fixture', 'manifests')

unless defined? Dotfile
  require File.join(File.dirname(File.dirname(__FILE__)), 'lib', 'config', 'init')
end

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.order = 'random'
  config.add_setting :agree_to_prompt, default: true

  config.before(:each) do
    allow($stdout).to receive(:print)
    allow($stdout).to receive(:print)
    allow($stdin).to receive(:gets) { RSpec.configuration.agree_to_prompt ? "y\r\n" : "n\r\n" }
    allow_any_instance_of(Object).to receive(:system).and_return(true)

    FileUtils.mkdir_p File.join(SPEC_TMP_DIR, 'code')
    FileUtils.copy_entry FIXTURE_SOURCE_PATH, SOURCE_BASE_PATH
    FileUtils.copy_entry FIXTURE_TARGET_PATH, TARGET_BASE_PATH
  end

  config.around(:each) do |example|
    ClimateControl.modify HOME: SPEC_TMP_DIR do
      example.run
    end
  end

  config.after(:each) do
    FileUtils.rm_r SPEC_TMP_DIR
  end
end
