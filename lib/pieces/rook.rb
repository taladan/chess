# frozen_string_literal: true

require_relative './piece'

# Still need to make a spec for this class
# rook chess piece
class Rook < Piece
  # return array of possible moves
  def possible_moves
    (1..8).flat_map do |spaces|
      [
        { up: spaces },
        { down: spaces },
        { left: spaces },
        { right: spaces }
      ]
    end
  end
end
