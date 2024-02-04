# frozen_string_literal: true

require 'position'

describe Position do
  describe '#xy' do
    it 'returns a positional array in x/y order' do
      position = Position.new(:b3)
      expect(position.xy).to eq([2, 1])
    end
  end

  describe '#yx' do
    it 'returns a positional array in y/x order' do
      position = Position.new(:b3)
      expect(position.yx).to eq([1, 2])
    end
  end

  describe '#relative_position' do
    it 'returns a position object' do
      position = Position.new(:b5)
      expect(position.relative_postion(up:1)).to be_a(Position)
    end
  end
  
  describe '#relative_position' do
    it 'has a file_and_rank of :b6' do
      position = Position.new(:b5)
      expect(position.relative_postion(up:1).file_and_rank).to eq(:b6)
    end
  end
end