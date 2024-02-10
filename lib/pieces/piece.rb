# frozen_string_literal: true

# parent class for chess pieces
# Methods:
# #possible_moves - return array of possible moves based on piece movement
#                   algorithm
class Piece
  attr_reader :color, :pieces
  attr_accessor :current_square

  def initialize(color=nil)
    @color = color
    @current_square = :tray
    @already_moved = false
  end

  # return array of possible moves
  def possible_moves
    []
  end

  def create_piece(type, color)
    case type
    when :pawn then Pawn.new(color)
    when :rook then Rook.new(color)
    when :knight then Knight.new(color)
    when :bishop then Bishop.new(color)
    when :queen then Queen.new(color)
    when :king then King.new(color)
    end
  end

  def is_pawn?
    instance_of?(Pawn)
  end
end
