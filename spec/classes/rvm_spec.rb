require 'spec_helper'

describe Rvm do
  let(:rvm) { Rvm.new }

  it_should_behave_like 'a decideable object' do
    let(:decideable) { Rvm.new }
  end

  describe '.install' do
    it 'calls the install instance method' do
      expect_any_instance_of(Rvm).to receive(:install).once.with(no_args)
      Rvm.install
    end
  end

  describe '#install' do
    before(:each) { rvm.stub(:ask).and_return(true) }

    it 'asks permission before proceeding' do
      expect(rvm).to receive(:ask).ordered
      expect(ConsoleNotifier).to receive(:banner).ordered
      expect(rvm).to receive(:system).ordered
      rvm.install
    end

    it 'does not proceed if permission refused' do
      rvm.stub(:ask).and_return(false)
      expect(rvm).to receive(:ask).ordered
      expect(ConsoleNotifier).not_to receive(:banner)
      expect(rvm).not_to receive(:system)
      rvm.install
    end

    it 'outputs a description and calls the RVM installer' do
      expect(ConsoleNotifier).to receive(:banner).with 'Installing RVM'
      rvm.install
    end

    it 'calls the RVM installer' do
      expect(rvm).to receive(:system).with('\\curl -sSL https://get.rvm.io | bash -s stable --ruby')
      rvm.install
    end
  end
end
