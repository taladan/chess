# frozen_string_literal: true

require_relative './piece.rb'

# Knight chess piece
class Knight < Piece
  def possible_moves
    [
      { up: 1, left: 2 },
      { up: 2, right: 1 },
      { up: 1, left: 2 },
      { up: 2, right: 1 },
      { down: 1, left: 2 },
      { down: 2, right: 1 },
      { down: 1, left: 2 },
      { down: 2, right: 1 }
    ]
  end
end
