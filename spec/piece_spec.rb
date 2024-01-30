# frozen_string_literal: true

require 'piece'

describe Piece do
  describe '#color' do
    it 'returns the piece color when queried' do
      piece = Piece.new(:white)
      expect(piece.color).to eq(:white)
    end
  end

  describe '#current_square' do
    it 'returns a symbol' do
      current_square = Piece.new(:white).current_square
      expect(current_square).to be_a(Symbol)
    end
  end

  describe '#possible_moves' do
    it 'returns an array' do
      possible_moves = Piece.new(:black).possible_moves
      expect(possible_moves).to be_an(Array)
    end
  end
end