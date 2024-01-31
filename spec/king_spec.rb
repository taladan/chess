# frozen_string_literal: true

require 'king'

describe King do
  describe '#possible_moves' do
    it 'returns an array' do
      possible_moves = King.new(:black).possible_moves
      expect(possible_moves).to be_an(Array)
    end
  end

  describe '#possible_moves' do
    it 'returns the expected array' do
      piece = King.new(:black)
      expected = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]
      possible_moves = piece.possible_moves
      expect(possible_moves).to eq(expected)
    end
  end
end