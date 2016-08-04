require 'spec_helper'

describe ConsoleNotifier do
  let(:banner_input)              { 'This is the banner text' }
  let(:banner_output)             { '# This is the banner text                                  #' }
  let(:long_banner_input)         { 'This text is extremely long and must be wrapped so that it does not explode out of the side' }
  let(:long_banner_output_line_1) { '# This text is extremely long and must be wrapped so that  #' }
  let(:long_banner_output_line_2) { '# it does not explode out of the side                      #' }

  subject { ConsoleNotifier.new }

  describe '#banner' do
    it 'should wrap the banner text in hashes' do
      expect($stdout).to receive(:puts).with("\n#{'#' * 60}").ordered
      expect($stdout).to receive(:puts).with(banner_output).ordered
      expect($stdout).to receive(:puts).with("#{'#' * 60}\n\n").ordered
      subject.banner(banner_input)
    end

    it 'should wrap lines longer than 76 characters' do
      expect($stdout).to receive(:puts).with("\n#{'#' * 60}").ordered
      expect($stdout).to receive(:puts).with(long_banner_output_line_1).ordered
      expect($stdout).to receive(:puts).with(long_banner_output_line_2).ordered
      expect($stdout).to receive(:puts).with("#{'#' * 60}\n\n").ordered
      subject.banner(long_banner_input)
    end
  end
end
