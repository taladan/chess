# frozen_string_literal: true

# parent class for chess pieces
# Methods:
# #possible_moves - return array of possible moves based on piece movement
#                   algorithm
class Piece
  attr_reader :color
  attr_accessor :current_square

  def initialize(color)
    @color = color
    @current_square = :tray
  end

  # return array of possible moves
  def possible_moves
    []
  end
end