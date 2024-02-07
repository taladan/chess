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
end