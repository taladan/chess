# frozen_string_literal: true

require './lib/pieces/knight.rb'

describe Knight do
  describe '#possible_moves' do
    it 'returns an array' do
      possible_moves = Knight.new(:black).possible_moves
      expect(possible_moves).to be_an(Array)
    end
  end
end
