require 'spec_helper'

describe Notifier do
  let(:banner_input)              { 'This is the banner text' }
  let(:banner_output)             { '# This is the banner text                                  #' }
  let(:long_banner_input)         { 'This text is extremely long and must be wrapped so that it does not explode out of the side' }
  let(:long_banner_output_line_1) { '# This text is extremely long and must be wrapped so that  #' }
  let(:long_banner_output_line_2) { '# it does not explode out of the side                      #' }

  subject { Notifier.new }

  describe '#banner' do
    it 'should wrap the banner text in hashes' do
      $stdout.should_receive(:puts).with('#' * 60).ordered
      $stdout.should_receive(:puts).with(banner_output).ordered
      $stdout.should_receive(:puts).with('#' * 60).ordered
      subject.banner(banner_input)
    end

    it 'should wrap lines longer than 76 characters' do
      $stdout.should_receive(:puts).with('#' * 60).ordered
      $stdout.should_receive(:puts).with(long_banner_output_line_1).ordered
      $stdout.should_receive(:puts).with(long_banner_output_line_2).ordered
      $stdout.should_receive(:puts).with('#' * 60).ordered
      subject.banner(long_banner_input)
    end
  end
end
