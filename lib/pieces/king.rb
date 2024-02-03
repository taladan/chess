# frozen_string_literal: true

require_relative './piece.rb'

# King chess piece
class King < Piece

  def possible_moves 
    [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]
  end
end