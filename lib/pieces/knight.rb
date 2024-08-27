# frozen_string_literal: true

require_relative './piece'

# Knight chess piece
class Knight < Piece
  def possible_moves
    [
      { up: 1, left: 2 },
      { up: 2, right: 1 },
      { up: 1, right: 2 },
      { up: 2, left: 1 },
      { down: 1, left: 2 },
      { down: 2, right: 1 },
      { down: 1, left: 2 },
      { down: 2, left: 1 }
    ]
  end

  def icon
    color == :white ? '♘'.cyan : '♞'.light_red
  end
end
