# frozen_string_literal: true

require './lib/pieces/knight.rb'

describe Knight do
  describe '#possible_moves' do
    it 'returns an array' do
      possible_moves = Knight.new(:black).possible_moves
      expect(possible_moves).to be_an(Array)
    end
  end

  describe '#possible_moves' do
    it 'returns the expected array' do
      piece = Knight.new(:black)
      expected = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], 
                  [1, -2], [1, 2], [2, -1], [2, 1]]
      possible_moves = piece.possible_moves
      expect(possible_moves).to eq(expected)
    end
  end
end
