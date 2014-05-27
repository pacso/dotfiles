require 'spec_helper'

describe Decision do
  let(:input) { double('input') }
  let(:output) { double('output').as_null_object }
  let(:decision) { Decision.new(input, output) }
  let(:question) { 'What?' }
  let(:question_output) { "#{question} [ynq]: " }

  describe '#ask' do
    before(:each) { input.stub(:gets) { response } }

    context 'positive response' do
      let(:response) { "y\r\n" }

      it 'outputs the question' do
        output.should_receive(:print).with(question_output)
        decision.ask(question)
      end

      it 'prompts for the answer' do
        input.should_receive(:gets)
        decision.ask(question)
      end

      it 'returns true if response is y' do
        output.should_receive(:print).with(question_output)
        expect(decision.ask(question)).to be_true
      end
    end

    context 'negative response' do
      let(:response) { "n\r\n" }

      it 'returns false if response is n' do
        output.should_receive(:print).with(question_output)
        expect(decision.ask(question)).to be_false
      end
    end

    context 'invalid responses' do
      before(:each) do
        input.stub(:gets).and_return("x\r\n", "g\r\n", "y\r\n")
      end

      it 'repeats the question until a valid response is provided' do
        output.should_receive(:print).exactly(3).times.with(question_output)
        decision.ask(question)
      end
    end

    context 'indecisive response' do
      let(:response) { "q\r\n" }

      it 'terminates execution' do
        output.should_receive(:print).with(question_output)
        expect { decision.ask(question) }.to raise_exception SystemExit
      end
    end
  end
end
