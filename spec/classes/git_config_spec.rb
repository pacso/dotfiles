require 'spec_helper'

describe GitConfig do

  let(:git_config) { GitConfig.new }

  let(:input) { StringIO.new }
  let(:output) { StringIO.new }
  let(:terminal) { HighLine.new(input, output) }

  before(:each) do
    allow(HighLine).to receive(:new).and_return(terminal)
  end

  describe('.set_name') do
    it 'prompts for your name' do
      input << "Joe Bloggs\n"
      input.rewind

      expect(git_config).to receive(:system).with("git config --global user.name Joe Bloggs")
      git_config.set_name
      expect(output.string).to eq("Name\n")
    end
  end

  describe('.set_email') do
    it 'prompts for and sets your email address in global config' do
      input << "joe.bloggs@email.com\n"
      input.rewind

      expect(git_config).to receive(:system).with("git config --global user.email joe.bloggs@email.com")
      git_config.set_email
      expect(output.string).to eq("Email\n")
    end
  end

  describe('.set_aliases') do
    context('accepting all defaults') do
      it 'sets all default aliases in global config' do
        input << "y\n\n\n\n\n"
        input.rewind

        expect(git_config).to receive(:system).ordered.with('git config --global alias.co checkout')
        expect(git_config).to receive(:system).ordered.with('git config --global alias.br branch')
        expect(git_config).to receive(:system).ordered.with('git config --global alias.ci commit')
        expect(git_config).to receive(:system).ordered.with('git config --global alias.st status')

        git_config.set_aliases
      end

      it 'sets alternative defaults in global config if provided' do
        input << "y\n\n\nxx\n\n"
        input.rewind

        expect(git_config).to receive(:system).ordered.with('git config --global alias.co checkout')
        expect(git_config).to receive(:system).ordered.with('git config --global alias.br branch')
        expect(git_config).to receive(:system).ordered.with('git config --global alias.xx commit')
        expect(git_config).to receive(:system).ordered.with('git config --global alias.st status')

        git_config.set_aliases
      end

      it 'does not set aliases if you initially say no' do
        input << "n\n"
        input.rewind

        expect(git_config).not_to receive(:set_alias)

        git_config.set_aliases
      end
    end
  end
end
