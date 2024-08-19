# frozen_string_literal: true

require_relative './piece'

# King chess piece
class King < Piece
  def possible_moves
    moveset = [
      { up: 1 },
      { left: 1 },
      { right: 1 },
      { down: 1 },
      { up: 1, left: 1 },
      { up: 1, right: 1 },
      { down: 1, left: 1 },
      { down: 1, right: 1 }
    ]
    # Here we add :left 2 and :right 2 if the king hasn't moved for Castling rule
    moveset.concat([left: 2], [right: 2]) unless @already_moved
    moveset.flatten
  end

  def icon
    color == :white ? '♔'.cyan : '♚'.light_red
  end
end
