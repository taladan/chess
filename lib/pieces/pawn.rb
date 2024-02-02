# frozen_string_literal: true

require_relative './piece.rb'

# pawn object
class Pawn < Piece
  attr_accessor :already_moved

  def initialize(color)
    super
    @already_moved = false
  end

  # Pawns can only move 'forward' from starting position, so :white has a
  # different moveset from :black
  def possible_moves
    @color == :white ? white_moveset : black_moveset
  end

  private

  def white_moveset
    if @already_moved
      [[0, 1], [1, 1], [-1, 1]]
    else
      [[0, 1], [0, 2], [1, 1], [-1, 1]]
    end
  end

  def black_moveset
    if @already_moved
      [[0, -1], [1, -1], [-1, -1]]
    else
      [[0, -1], [0, -2], [1, -1], [-1, -1]]
    end
  end
end
