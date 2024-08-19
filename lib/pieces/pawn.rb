# frozen_string_literal: true

require_relative './piece'

# pawn object
class Pawn < Piece
  attr_accessor :already_moved

  # Pawns can only move 'forward' from starting position, so :white has a
  # different moveset from :black
  def possible_moves
    @color == :white ? white_moveset : black_moveset
  end

  # remove vertical moves and return array of threatened positions
  def threatened_squares
    moves = []
    possible_moves.each do |move|
      next if move.length == 1

      moves.push({ move => @current_square.relative_position(**move) })
    end
    moves
  end

  def icon
    color == :white ? '♙'.cyan : '♟'.light_red
  end

  private

  def white_moveset
    if @already_moved
      [
        { up: 1 },
        { up: 1, left: 1 },
        { up: 1, right: 1 }
      ]
    else
      [
        { up: 1 },
        { up: 2 },
        { up: 1, left: 1 },
        { up: 1, right: 1 }
      ]
    end
  end

  def black_moveset
    if @already_moved
      [
        { down: 1 },
        { down: 1, left: 1 },
        { down: 1, right: 1 }
      ]
    else
      [
        { down: 1 },
        { down: 2 },
        { down: 1, left: 1 },
        { down: 1, right: 1 }
      ]
    end
  end
end
