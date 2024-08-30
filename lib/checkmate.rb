# frozen_string_literal: true

require_relative 'check'

class Checkmate < Check
  # return boolean - test all possible moves to see if check can be resolved
  # If a piece's move can resolve the check status, return true
  def checkmate?
    return false unless check?

    output = true
    kings_in_check.each do |king|
      @board.find_pieces_by_color(king.color).each do |piece|
        origin = piece.current_square.to_sym
        piece.threatened_squares.each do |move|
          move.values.each do |value|
            working_board = deep_copy_board
            play(working_board, origin, value)
            return false unless Check.new(working_board).check?
          end
        end
      end
    end
  end

  # return an identical deep copy of board object for move testing
  def deep_copy_board
    Marshal.load(Marshal.dump(@board))
  end

  # advance piece to square
  def play(board_object, origin, square)
    return unless board_object.on_board?(square)

    # We don't care about invalid moves in testing for checkmate
    begin
      board_object.move_piece(origin, square)
    rescue InvalidMove => e
    end
  end
end
