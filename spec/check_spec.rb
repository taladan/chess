# frozen_string_literal: true

require 'check'
require 'board'

describe Check do
  describe '#check?' do
    it 'returns false when a king piece is not in check' do
      board = Board.new
      expect(Check.new(board).check?).to be(false)
    end

    it 'returns true when a king piece is in check' do
      board = Board.new
      board.remove_piece_from!(:e2)
      board.put(board.remove_piece_from!(:a8), :e4)
      expect(Check.new(board).check?).to be(true)
    end
  end

  describe '#kings_in_check' do
    it 'returns an empty array when no king is in check' do
      board = Board.new
      expect(Check.new(board).kings_in_check).to be_empty
    end

    it 'returns an array of length 1 when one king is in check' do
      board = Board.new(clear: true)
      board.put(:queen, :e5, :black)
      board.put(:king, :e1, :white)
      board.put(:king, :e8, :black)
      expect(Check.new(board).kings_in_check.size).to eq(1)
    end

    it 'returns an array of length 2 when two kings are in check' do
      board = Board.new(clear: true)
      board.put(:queen, :e5, :black)
      board.put(:queen, :e6, :white)
      board.put(:king, :e1, :white)
      board.put(:king, :e8, :black)
      expect(Check.new(board).kings_in_check.size).to eq(2)
    end
  end
end
