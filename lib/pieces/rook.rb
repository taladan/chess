# frozen_string_literal: true

require_relative './piece.rb'

# Still need to make a spec for this class
# rook chess piece
class Rook < Piece

  # return array of possible moves
  def possible_moves
    [
      { up: 1 },
      { down: 1 },
      { left: 1 },
      { right: 1 },
      { up: 2 },
      { down: 2 },
      { left: 2 },
      { right: 2 },
      { up: 3 },
      { down: 3 },
      { left: 3 },
      { right: 3 },
      { up: 4 },
      { down: 4 },
      { left: 4 },
      { right: 4 },
      { up: 5 },
      { down: 5 },
      { left: 5 },
      { right: 5 },
      { up: 6 },
      { down: 6 },
      { left: 6 },
      { right: 6 },
      { up: 7 },
      { down: 7 },
      { left: 7 },
      { right: 7 },
      { up: 8 },
      { down: 8 },
      { left: 8 },
      { right: 8 }
    ]
  end
end
