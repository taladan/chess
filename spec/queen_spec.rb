# frozen_string_literal: true

require './lib/pieces/queen.rb'

describe Queen do
  describe '#possible_moves' do
    it 'returns an array' do
      possible_moves = Queen.new(:black).possible_moves
      expect(possible_moves).to be_an(Array)
    end
  end

  describe '#possible_moves' do
    it 'returns the expected array' do
      piece = Queen.new(:black)
      expected = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7], 
                  [8, 8], [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6],
                  [7, -7], [8, -8], [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5],
                  [-6, 6], [-7, 7], [-8, 8], [-1, -1], [-2, -2], [-3, -3],
                  [-4, -4], [-5, -5], [-6, -6], [-7, -7], [-8, -8], [0, 1],
                  [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [0, 8],
                  [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7],
                  [0, -8], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0],
                  [7, 0], [8, 0], [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0],
                  [-6, 0], [-7, 0], [-8, 0]]
      possible_moves = piece.possible_moves
      expect(possible_moves).to eq(expected)
    end
  end
end
