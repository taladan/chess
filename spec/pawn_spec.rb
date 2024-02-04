# frozen_string_literal: true

require './lib/pieces/pawn.rb'

describe Pawn do
  describe '#possible_moves' do
    it 'returns an array' do
      possible_moves = Pawn.new(:black).possible_moves
      expect(possible_moves).to be_an(Array)
    end
  end
end
