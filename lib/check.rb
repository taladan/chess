# frozen_string_literal: true

require_relative 'threat'

class Check
  attr_reader :black_king, :white_king

  def initialize(board)
    @board = board
    find_kings
    @threats = Threat.new(@board).all_threats.values.flatten
  end

  # return boolean true if either king is currently in check
  def check?
    @threats.include?(@white_king.current_square) || @threats.include?(@black_king.current_square)
  end

  # return array of all kings currently in check
  def kings_in_check
    [@white_king, @black_king].select do |king|
      @threats.include?(king.current_square)
    end
  end

  private

  # this sets the king square variables to position objects
  def find_kings
    @board.squares.flatten.find_all do |square|
      if square.occupied? && square.piece.king?
        square.piece.color == :white ? @white_king = square.piece : @black_king = square.piece
      end
    end
  end
end
