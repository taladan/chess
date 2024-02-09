# frozen_string_literal: true

require 'board'

describe Board do
  describe "#get" do
    it "returns a square object from a string" do
      square = Board.new.get("A1")
      expect(square).to be_a(Square)
    end

    it "returns a square object from a symbol" do
      square = Board.new.get(:g4)
      expect(square).to be_a(Square)
    end
  end

  describe "#get_piece" do
    it "returns a piece object when passed a square that has a piece in it" do
      piece = Board.new.get_piece(:a1)
      expect(piece).to be_a(Piece)
    end

    it "returns nil when asked to retrieve a piece from a square that is empty" do
      piece = Board.new.get_piece(:a5)
      expect(piece).to be(nil)
    end
  end

  describe "#on_board?" do
    it "returns true when a position known to be on the board is given" do
      board = Board.new
      pos = :a1
      expect(board.on_board?(pos)).to be(true)
    end
  end

  describe "#on_board?" do
    it "returns false when a position known to be off the board is given" do
      board = Board.new
      pos = :a12
      expect(board.on_board?(pos)).to be(false)
    end
  end

  describe '#put' do
    it "puts a new piece on the board when passed a symbol" do
      board = Board.new
      board.put(:queen, :e5, :black)
      expect(board.get(:e5).piece).to be_a(Queen)
    end
  end

  describe '#put' do
    it "puts an existing piece on the board" do
      board = Board.new
      piece = board.get(:e2).piece
      board.put(piece, :c5)
      moved_piece = board.get(:c5).piece
      expect(moved_piece).to be(piece)
    end
  end

  describe '#remove_piece_from' do
    it 'returns a piece object' do
      board = Board.new
      piece = board.remove_piece_from(:c2)
      expect(piece).to be_a(Pawn)
    end
  end

  describe '#remove_piece_from' do
    it 'removes a piece from a square' do
      board = Board.new
      piece = board.remove_piece_from(:g2)
      square = board.get(:g2)
      expect(square.piece).to be(nil)
    end
  end
end