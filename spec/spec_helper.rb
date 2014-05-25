require 'rubygems'
require 'rake'

require File.join(File.dirname(File.dirname(__FILE__)), 'lib', 'config', 'init')

RSpec.configure do |config|
  config.order = 'random'
end
