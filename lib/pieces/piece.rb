# frozen_string_literal: true

# parent class for chess pieces
# Methods:
# #possible_moves - return array of possible moves based on piece movement
#                   algorithm
class Piece
  attr_reader :color, :pieces
  attr_accessor :current_square

  def initialize(color = nil)
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

  def pawn?
    instance_of?(Pawn)
  end

  def king?
    instance_of?(King)
  end

  def knight?
    instance_of?(Knight)
  end

  def rook?
    instance_of?(Rook)
  end

  def update
    @already_moved = true
  end

  # has the piece moved at least once?
  def has_moved?
    @already_moved
  end
end
