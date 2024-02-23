# frozen_string_literal: true

require 'threat'
require 'board'

describe Threat do
  describe '#all_threats' do
    it 'returns a hash object' do
      board = Board.new
      threat = Threat.new(board)
      expect(threat.all_threats).to be_a(Hash)
    end

    it 'is length 32 when passed a new board object' do
      board = Board.new
      threat = Threat.new(board)
      expect(threat.all_threats.length).to be(32)
    end
  end

  describe '#squares_threatened_by_black_pieces' do
    it 'returns a hash object' do
      board = Board.new
      threat = Threat.new(board)
      expect(threat.squares_threatened_by_black_pieces).to be_a(Hash)
    end

    it 'is length 16 when passed a new board object' do
      board = Board.new
      threat = Threat.new(board)
      expect(threat.squares_threatened_by_black_pieces.length).to be(16)
    end
  end

  describe '#squares_threatened_by_white_pieces' do
    it 'returns a hash object' do
      board = Board.new
      threat = Threat.new(board)
      expect(threat.squares_threatened_by_white_pieces).to be_a(Hash)
    end

    it 'is length 16 when passed a new board object' do
      board = Board.new
      threat = Threat.new(board)
      expect(threat.squares_threatened_by_white_pieces.length).to be(16)
    end
  end
end