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
  
  describe '#==' do
    it 'equals an object with identical data' do
      position1 = Position.new(:a1)
      position2 = Position.new(:a1)
      expect(position1).to eq(position2)
    end
  end
  
  describe '#==' do
    it 'does not equan an object with different data' do
      position1 = Position.new(:b2)
      position2 = Position.new(:h3)
      expect(position1).not_to eq(position2)
    end
  end
end