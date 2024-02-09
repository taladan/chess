# frozen_string_literal: true

require './lib/board.rb'
require './lib/move.rb'

describe Move do
  describe '#valid?' do
    it 'returns true when a piece can move to a given square' do
      board = Board.new
      piece = board.get_piece(:a2)
      move = Move.new(board, piece, :a3)
      expect(move.valid?).to be(true)
    end
  end
end