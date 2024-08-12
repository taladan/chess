# frozen_string_literal: true require 'check'

require 'check'

class Checkmate < Check
  # return boolean - test all possible moves to see if check can be resolved
  # If a piece's move can resolve the check status, return true
  def checkmate?
    return false unless check?

    output = true
    kings_in_check.each do |king|
      @board.find_pieces_by_color(king.color).each do |piece|
        next if output == false

        origin = piece.current_square.to_sym
        piece.threatened_squares.each do |move|
          move.values.each do |value|
            next if output == false

            working_board = deep_copy_board
            play(working_board, origin, value)
            output = Check.new(working_board).check?
          end
        end
      end
    end
    output
  end

  # return an identical deep copy of board object for move testing
  def deep_copy_board
    Marshal.load(Marshal.dump(@board))
  end

  # advance piece to square
  def play(board_object, origin, square)
    return unless board_object.on_board?(square)

    board_object.move_piece(origin, square)
  end
end
