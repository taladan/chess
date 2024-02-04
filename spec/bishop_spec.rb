# frozen_string_literal: true

require './lib/pieces/bishop.rb'

describe Bishop do
  describe '#possible_moves' do
    it 'returns an array' do
      possible_moves = Bishop.new(:black).possible_moves
      expect(possible_moves).to be_an(Array)
    end
  end
end
