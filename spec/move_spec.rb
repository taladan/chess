# frozen_string_literal: true

require './lib/board'
require './lib/move'

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
      board = Board.new(clear: true)
      board.put(:rook, :e3, :white)
      board.put(:queen, :e4, :black)
      board.put(:king, :e1, :white)
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

    it 'returns false when a king tries to move into a threatened square' do
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

  describe 'castle?' do
    it 'returns false when moving piece is not a king' do
      board = Board.new
      move = Move.new(board, :b1, :c3)
      expect(move.castle?).to be(false)
    end

    it 'returns false when king is moving to the next rank' do
      board = Board.new
      board.remove_piece_from!(:e2)
      move = Move.new(board, :e1, :e2)
      expect(move.castle?).to be(false)
    end

    it 'returns false when king is moving only one space' do
      board = Board.new
      board.remove_piece_from!(:f1)
      move = Move.new(board, :e1, :f1)
      expect(move.castle?).to be(false)
    end

    it 'returns false if the king has already moved' do
      board = Board.new
      board.remove_piece_from!(:f1)
      board.remove_piece_from!(:g1)
      board.move_piece(:e1, :f1)
      board.move_piece(:f1, :e1)
      move = Move.new(board, :e1, :g1)
      expect(move.castle?).to be(false)
    end

    it 'returns false if the rook being castled has already moved' do
      board = Board.new
      %i[f1 g1].each do |square|
        board.remove_piece_from!(square)
      end
      board.move_piece(:h1, :g1)
      board.move_piece(:g1, :h1)
      move = Move.new(board, :e1, :g1)
      expect(move.castle?).to be(false)
    end

    it 'returns false if the rook square is empty' do
      board = Board.new
      %i[f1 g1 h1].each do |square|
        board.remove_piece_from!(square)
      end
      move = Move.new(board, :e1, :g1)
      expect(move.castle?).to be(false)
    end

    it 'returns false if there is a non-rook piece in the rook square' do
      board = Board.new
      %i[f1 g1 h1].each do |square|
        board.remove_piece_from!(square)
      end
      board.put(:bishop, :h1, :black)
      move = Move.new(board, :e1, :g1)
      expect(move.castle?).to be(false)
    end

    it 'returns false if the king is attempting to castle out of check' do
      board = Board.new
      %i[f1 g1 e2].each do |square|
        board.remove_piece_from!(square)
      end
      board.put(:queen, :e5, :black)
      move = Move.new(board, :e1, :g1)
      expect(move.castle?).to be(false)
    end

    it 'returns false if the destination square the king is moving to is threatened' do
      board = Board.new
      %i[f1 g1 g2].each do |square|
        board.remove_piece_from!(square)
      end
      board.put(:queen, :g5, :black)
      move = Move.new(board, :e1, :g1)

      expect(move.castle?).to be(false)
    end

    it 'returns false if the square the king is moving through to castle is threatened' do
      board = Board.new
      %i[f1 g1 f2].each do |square|
        board.remove_piece_from!(square)
      end
      board.put(:queen, :f5, :black)
      move = Move.new(board, :e1, :g1)

      expect(move.castle?).to be(false)
    end

    it 'returns true when a valid castle maneuver is made' do
      board = Board.new
      %i[f1 g1].each do |square|
        board.remove_piece_from!(square)
      end
      last_move = Move.new(board, :e1, :g1)
      expect(last_move.castle?).to be(true)
    end
  end
end
