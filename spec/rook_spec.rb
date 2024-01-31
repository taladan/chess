# frozen_string_literal: true

require 'rook'

describe Rook do
  describe '#possible_moves' do
    it 'returns an array' do
      possible_moves = Rook.new(:black).possible_moves
      expect(possible_moves).to be_an(Array)
    end

    it 'returns the expected array' do
      possible_moves = Rook.new(:black).possible_moves
      expected = [[-8, 0], [-7, 0], [-6, 0], [-5, 0], [-4, 0],
                  [-3, 0], [-2, 0], [-1, 0], [1, 0], [2, 0],
                  [3, 0], [4, 0], [5, 0], [6, 0], [7, 0], [8, 0],
                  [0, -8], [0, -7], [0, -6], [0, -5], [0, -4],
                  [0, -3], [0, -2], [0, -1], [0, 1], [0, 2],
                  [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [0, 8]]
      expect(possible_moves).to eq(expected)
    end
  end
end
