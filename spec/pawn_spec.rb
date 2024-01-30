# frozen_string_literal: true

require 'pawn'

describe Pawn do
  describe '#color' do
    it 'returns the piece color when queried' do
      piece = Pawn.new(:white)
      expect(piece.color).to eq(:white)
    end
  end

  describe '#current_square' do
    it 'returns a symbol' do
      current_square = Pawn.new(:white).current_square
      expect(current_square).to be_a(Symbol)
    end
  end

  describe '#possible_moves' do
    it 'returns an array' do
      possible_moves = Pawn.new(:black).possible_moves
      expect(possible_moves).to be_an(Array)
    end
  end

  describe '#possible_moves' do
    it 'when a pawn is black and has not moved, its return array includes [0,-2]' do
      piece = Pawn.new(:black)
      possible_moves = piece.possible_moves.include?([0,-2])
      expect(possible_moves).to be(true)
    end
  end

  describe '#possible_moves' do
    it 'when a pawn is black and has moved its return array does not include [0,-2]' do
      piece = Pawn.new(:black)
      piece.already_moved = true
      possible_moves = piece.possible_moves.include?([0,-2])
      expect(possible_moves).to be(false)
    end
  end

  describe '#possible_moves' do
    it 'when a pawn is white and has not moved, its return array includes [0,2]' do
      possible_moves = Pawn.new(:white).possible_moves.include?([0,2])
      expect(possible_moves).to be(true)
    end
  end
 
  describe '#possible_moves' do
    it 'when a pawn is white and has moved, its return array does not include [0,2]' do
      piece = Pawn.new(:white)
      piece.already_moved = true
      possible_moves = piece.possible_moves.include?([0,2])
      expect(possible_moves).to be(false)
    end
  end
end
