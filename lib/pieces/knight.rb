# frozen_string_literal: true

require_relative './piece.rb'

# Knight chess piece
class Knight < Piece

  def possible_moves
    [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
  end
end