require 'spec_helper'

describe Dotfile do
  describe '#source_exists?' do
    it 'returns true when file exists' do
      d = Dotfile.new('new_file')
      expect(d.source_exists?).to be_true
    end

    it 'returns false when file missing' do
      d = Dotfile.new('missing')
      expect(d.source_exists?).to be_false
    end

    it 'returns false when file empty' do
      d = Dotfile.new
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

    it 'returns false when file empty' do
      d = Dotfile.new
      expect(d.destination_exists?).to be_false
    end
  end
end
