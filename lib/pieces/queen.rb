# frozen_string_literal: true

require_relative './piece'

# Queen chess piece
class Queen < Piece
  def possible_moves
    (1..8).flat_map do |spaces|
      [
        { up: spaces },
        { down: spaces },
        { left: spaces },
        { right: spaces },
        { up: spaces, left: spaces },
        { up: spaces, right: spaces },
        { down: spaces, left: spaces },
        { down: spaces, right: spaces }
      ]
    end
  end
end
