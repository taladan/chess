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

    it 'returns false when a piece cannot move to a given square' do
      board = Board.new
      piece = board.get_piece(:a2)
      move = Move.new(board, piece, :b3)
      expect(move.valid?).to be(false)
    end

    it 'returns false when a piece cannot move because it threatens the moving players king' do
      board = Board.new
      board.remove_piece_from!(:e3)
      board.put(:rook, :e3, :white)
      board.put(:queen, :e4, :black)
      piece = board.get_piece(:e3)
      move = Move.new(board, piece, :a3)
      expect(move.valid?).to be(false)
    end

    it 'returns true when a knight leaps over a piece' do
      board = Board.new
      piece = board.get_piece(:b1)
      move = Move.new(board, piece, :c3)
      expect(move.valid?).to be(true)
    end

    it 'returns true when a pawn attacks a piece' do
      board = Board.new
      piece = board.get_piece(:b2)
      board.put(:rook, :c3, :black)
      move = Move.new(board, piece, :c3)
      expect(move.valid?).to be(true)
    end

    it 'returns true when a king tries to move into a threatened square' do
      board = Board.new
      board.put(:rook, :a3, :black)
      board.remove_piece_from!(:e2)
      king = board.get_piece(:e1)
      board.put(king, :e2)
      move = Move.new(board, king, :e3)
      expect(move.valid?).to be(false)
    end

    it 'returns true when a piece makes a legal capture' do
      board = Board.new
      board.put(:rook, :h6, :black)
      board.put(:knight, :a6, :white)
      move = Move.new(board, :h6, :a6)
      expect(move.valid?).to be(true)
    end
  end
end
