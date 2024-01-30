# frozen_string_literal: true

require './lib/piece'

describe Piece do
  describe '#name' do
    it 'returns the piece name when queried' do
      piece = Piece.new(:white, 'pawn')
      expect(piece.name).to eq('pawn')
    end
  end

  describe '#color' do
    it 'returns the piece color when queried' do
      piece = Piece.new(:white, 'rook')
      expect(piece.color).to eq(:white)
    end
  end

  describe '#current_square' do
    it 'returns a symbol' do
      current_square = Piece.new(:white,'rook').current_square
      expect(current_square).to be_a(Symbol)
    end
  end

  describe '#possible_moves' do
    it 'returns an array' do
      possible_moves = Piece.new(:black,'queen').possible_moves
      expect(possible_moves).to be_an(Array)
    end
  end
end