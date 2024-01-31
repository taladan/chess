# frozen_string_literal: true

require 'bishop'

describe Bishop do
  describe '#possible_moves' do
    it 'returns an array' do
      possible_moves = Bishop.new(:black).possible_moves
      expect(possible_moves).to be_an(Array)
    end
  end

  describe '#possible_moves' do
    it 'returns the expected array' do
      piece = Bishop.new(:black)
      expected = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
                  [8, 8], [1, -1], [2, -2], [3, -3], [4, -4], [5, -5],
                  [6, -6], [7, -7], [8, -8], [-1, 1], [-2, 2], [-3, 3],
                  [-4, 4], [-5, 5], [-6, 6], [-7, 7], [-8, 8], [-1, -1],
                  [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7], 
                  [-8, -8]]
      possible_moves = piece.possible_moves
      expect(possible_moves).to eq(expected)
    end
  end
end