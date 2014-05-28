require 'spec_helper'

shared_examples_for 'a decideable object' do
  before(:each) do
    unless respond_to?(:decideable)
      raise "You must provide instance method decideable"
    end
  end

  let(:question) { 'What?' }
  let(:question_output) { "#{question} [ynaq]: " }

  subject { decideable }
  it { should respond_to(:ask) }

  describe '#ask' do
    before(:each) { $stdin.stub(:gets) { response } }

    context 'positive response' do
      let(:response) { "y\r\n" }

      it 'outputs the question' do
        $stdout.should_receive(:print).with(question_output)
        subject.ask question
      end

      it 'prompts for the answer' do
        $stdin.should_receive(:gets)
        subject.ask question
      end

      it 'returns true if response is y' do
        expect(subject.ask question).to be_true
      end
    end

    context 'negative response' do
      let(:response) { "n\r\n" }

      it 'returns false if response is n' do
        expect(subject.ask question).to be_false
      end
    end

    context 'positive response for all' do
      let(:response) { "a\r\n" }

      it 'should automatically return true for subsequent questions' do
        $stdout.should_receive(:print).once.with(question_output)
        expect(subject.ask question).to be_true
        expect(subject.ask 'Another question?').to be_true
        expect(subject.ask 'A third question?').to be_true
      end
    end

    context 'invalid responses' do
      before(:each) do
        $stdin.stub(:gets).and_return("x\r\n", "g\r\n", "y\r\n")
      end

      it 'repeats the question until a valid response is provided' do
        $stdout.should_receive(:print).exactly(3).times.with(question_output)
        subject.ask question
      end
    end

    context 'indecisive response' do
      let(:response) { "q\r\n" }

      it 'terminates execution' do
        expect { subject.ask question }.to raise_exception SystemExit
      end
    end
  end
end
