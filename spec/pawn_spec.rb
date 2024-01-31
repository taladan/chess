# frozen_string_literal: true

require 'pawn'

describe Pawn do
  describe '#possible_moves' do
    it 'returns an array' do
      possible_moves = Pawn.new(:black).possible_moves
      expect(possible_moves).to be_an(Array)
    end
  end

  describe '#possible_moves' do
    it 'when a pawn is black and has not moved it returns the expected array' do
      piece = Pawn.new(:black)
      expected = [[0, -1], [0, -2], [1, -1], [-1, -1]]
      possible_moves = piece.possible_moves
      expect(possible_moves).to eq(expected)
    end
  end

  describe '#possible_moves' do
    it 'when a pawn is black and has moved it returns the expected array' do
      piece = Pawn.new(:black)
      expected = [[0, -1], [1, -1], [-1, -1]]
      piece.already_moved = true
      possible_moves = piece.possible_moves
      expect(possible_moves).to eq(expected)
    end
  end

  describe '#possible_moves' do
    it 'when a pawn is white and has not moved it returns the expected array' do
      possible_moves = Pawn.new(:white).possible_moves
      expected = [[0, 1], [0, 2], [1, 1], [-1, 1]]
      expect(possible_moves).to eq(expected)
    end
  end
 
  describe '#possible_moves' do
    it 'when a pawn is white and has moved it returns the expected array' do
      piece = Pawn.new(:white)
      expected = [[0, 1], [1, 1], [-1, 1]]
      piece.already_moved = true
      possible_moves = piece.possible_moves
      expect(possible_moves).to eq(expected)
    end
  end
end
