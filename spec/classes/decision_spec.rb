require 'spec_helper'

describe Decision do
  let(:input) { double('input').as_null_object }
  let(:output) { double('output').as_null_object }
  let(:decision) { Decision.new(input, output) }
  let(:question) { 'What?' }

  before(:each) do
    decision.question = question
  end

  describe '#ask' do
    it 'outputs the question' do
      output.should_receive(:puts).with(question)
      decision.ask!
    end

    it 'prompts for the answer' do
      input.should_receive(:gets)
      decision.ask!
    end

    it 'repeats the answer to the user' do
      input.stub(:gets) { "bananas!\r\n" }
      output.should_receive(:puts).with('What?')
      output.should_receive(:puts).with('The answer was: bananas!')
      decision.ask!
    end
  end
end
