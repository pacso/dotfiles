require 'spec_helper'

describe Rvm do
  before(:each) do
    Object.any_instance.stub(:system).and_return(true)
  end

  it_should_behave_like 'notifications' do
    let(:notifiable) { Rvm.new }
  end

  describe '.install' do
    it 'outputs a description and calls the RVM installer' do
      expect_any_instance_of(Rvm).to receive(:banner).with 'Installing RVM'
      Rvm.install
    end

    it 'calls the RVM installer' do
      expect_any_instance_of(Object).to receive(:system).with('\\curl -sSL https://get.rvm.io | bash -s stable --ruby')
      Rvm.install
    end
  end
end
