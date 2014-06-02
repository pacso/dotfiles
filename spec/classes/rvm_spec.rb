require 'spec_helper'

describe Rvm do
  describe '.install' do

    it 'outputs a description and calls the RVM installer' do
      expect(ConsoleNotifier).to receive(:banner).with 'Installing RVM'
      Rvm.install
    end

    it 'calls the RVM installer' do
      expect_any_instance_of(Object).to receive(:system).with('\\curl -sSL https://get.rvm.io | bash -s stable --ruby')
      Rvm.install
    end
  end
end
