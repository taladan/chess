# frozen_string_literal: true

require 'checkmate'
require 'board'

# Checkmate currently REQUIRES 2 kings on the board.  This may change.
describe Checkmate do
  describe '#checkmate?' do
    it 'returns false when a king piece is not in check or checkmate' do
      board = Board.new
      expect(Checkmate.new(board).checkmate?).to be(false)
    end

    it 'returns false when a king piece is in check, but not in checkmate' do
      board = Board.new(clear: true)
      board.put(:king, :e1, :white)
      board.put(:king, :h8, :black)
      board.put(:queen, :e5, :black)
      board.put(:rook, :a2, :white)
      expect(Checkmate.new(board).checkmate?).to be(false)
    end

    it 'returns true when a king piece is in checkmate' do
      board = Board.new(clear: true)
      board.put(:rook, :a8, :black)
      board.put(:knight, :b8, :black)
      board.put(:bishop, :c8, :black)
      board.put(:pawn, :a7, :black)
      board.put(:pawn, :b7, :black)
      board.put(:king, :c7, :black)
      board.put(:pawn, :c6, :black)
      board.put(:bishop, :d8, :white)
      board.put(:rook, :d1, :white)
      board.put(:pawn, :f2, :white)
      board.put(:pawn, :g2, :white)
      board.put(:pawn, :h2, :white)
      board.put(:king, :g1, :white)
      expect(Checkmate.new(board).checkmate?).to be(true)
    end

    it 'returns true when a king piece is in check but can resolve it by capture' do
      board = Board.new(clear: true)
      board.put(:queen, :e2, :black)
      board.put(:king, :h8, :black)
      board.put(:rook, :d1, :white)
      board.put(:rook, :d2, :white)
      board.put(:king, :e1, :white)
      expect(Checkmate.new(board).checkmate?).to be(false)
    end
  end
end
