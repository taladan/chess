# frozen_string_literal: true

require_relative './piece.rb'

# Still need to make a spec for this class
# rook chess piece
class Rook < Piece

  # return array of possible moves
  def possible_moves
    # return array of moves
    moves = []
    ranks = *(-8..8).to_a
    files = *(-8..8).to_a

    ranks.delete(0)
    ranks.each do |rank|
      moves.push([rank, 0])
    end
    files.delete(0)
    files.each do |file|
      moves.push([0, file])
    end
    moves
  end
end
