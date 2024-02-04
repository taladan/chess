# frozen_string_literal: true

require_relative './piece.rb'

# Bishop chess piece
class Bishop < Piece
  def possible_moves
    moves = []
    (1..8).to_a.each do |spaces_moved|
      moves.push({up: spaces_moved, left: spaces_moved})
      moves.push({down: spaces_moved, left: spaces_moved})
      moves.push({up: spaces_moved, right: spaces_moved})
      moves.push({down: spaces_moved, right: spaces_moved})
    end
    moves
  end
end
