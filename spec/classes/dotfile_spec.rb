require 'spec_helper'

describe Dotfile do
  describe '#new' do
    it 'raises ArgumentError if filename not given' do
      expect { Dotfile.new }.to raise_exception ArgumentError
    end

    it 'raises ArgumentError if filename is empty' do
      expect { Dotfile.new '' }.to raise_exception ArgumentError
    end

    it 'raises ArgumentError if filename contains whitespace' do
      expect { Dotfile.new ' ' }.to raise_exception ArgumentError
    end
  end

  describe '#source_exists?' do
    it 'returns true when file exists' do
      d = Dotfile.new('new_file')
      expect(d.source_exists?).to be_true
    end

    it 'returns false when file missing' do
      d = Dotfile.new('missing')
      expect(d.source_exists?).to be_false
    end
  end

  describe '#destination_exists?' do
    it 'returns true when file exists' do
      d = Dotfile.new('existing_file')
      expect(d.destination_exists?).to be_true
    end

    it 'returns false when missing' do
      d = Dotfile.new('non-existent_filename')
      expect(d.destination_exists?).to be_false
    end
  end
end
