# frozen_string_literal: true

require './lib/pieces/piece.rb'

describe Piece do
  describe '#color' do
    it 'returns the piece color when queried' do
      piece = Piece.new(:white)
      expect(piece.color).to eq(:white)
    end
  end

  describe '#create_piece' do
    it 'returns a Pawn object when called to create a pawn' do
      piece = Piece.new().create_piece(:pawn, :black)
      expect(piece).to be_a(Pawn)
    end
  end

  describe '#current_square' do
    it 'returns a symbol' do
      current_square = Piece.new(:white).current_square
      expect(current_square).to be_a(Symbol)
    end
  end

  describe '#pawn?' do
    it 'returns true when piece is a pawn' do
      require './lib/pieces/pawn.rb'
      piece = Pawn.new(:white)
      expect(piece.pawn?).to be(true)
    end

    it 'returns false when piece is not a pawn' do
      require './lib/pieces/rook.rb'
      piece = Rook.new(:black)
      expect(piece.pawn?).to be(false)
    end
  end

  describe '#possible_moves' do
    it 'returns an array' do
      possible_moves = Piece.new(:black).possible_moves
      expect(possible_moves).to be_an(Array)
    end
  end
end
