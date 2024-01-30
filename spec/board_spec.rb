# frozen_string_literal: true

require './lib/board'

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
end