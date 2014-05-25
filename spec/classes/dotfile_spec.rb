require 'spec_helper'

describe Dotfile do
  describe '#source_exists?' do
    it 'returns true when file exists' do
      d = Dotfile.new('spec/fixture/src/file')
      expect(d.source_exists?).to be_true
    end

    it 'returns false when file missing' do
      d = Dotfile.new('spec/fixture/src/missing')
      expect(d.source_exists?).to be_false
    end
  end
end
