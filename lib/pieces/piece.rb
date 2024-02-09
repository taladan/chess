# frozen_string_literal: true

# require all piece files

require_relative './pawn'
require_relative './rook'
require_relative './knight'
require_relative './bishop'
require_relative './queen'
require_relative './king'

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
    @pieces = {
      pawn: Pawn,
      rook: Rook,
      knight: Knight,
      bishop: Bishop,
      queen: Queen,
      king: King
    }
  end

  # return array of possible moves
  def possible_moves
    []
  end

  def is_pawn?
    instance_of?(Pawn)
  end
end
