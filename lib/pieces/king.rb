# frozen_string_literal: true

require_relative './piece.rb'

# King chess piece
class King < Piece

  def possible_moves 
    [
      {up: 1},
      {left: 1},
      {right: 1},
      {down: 1},
      {up: 1, left: 1},
      {up:1, right: 1},
      {down: 1, left: 1},
      {down:1, right: 1},
    ]
  end
end
