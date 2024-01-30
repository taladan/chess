# frozen_string_literal: true

# parent class for chess pieces
class Piece
  attr_reader :color, :name, :possible_moves
  attr_accessor :current_square

  def initialize(color, name)
    @color = color
    @name = name
    @current_square = :tray
    @possible_moves = get_moveset
  end
  
  def get_moveset
    return []
  end
end
