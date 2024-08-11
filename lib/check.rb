# frozen_string_literal: true

require 'pry-byebug'
require_relative 'threat'

class Check
  attr_reader :black_king, :white_king

  def initialize(board)
    @board = board
    find_kings
  end

  # this sets the king square variables to position objects
  def find_kings
    @board.squares.flatten.find_all do |square|
      if square.occupied? && square.piece.king?
        square.piece.color == :white ? @white_king = square.piece : @black_king = square.piece
      end
    end
  end

  # return boolean true if either king is currently in check
  def check?
    threats.include?(@white_king.current_square) || threats.include?(@black_king.current_square)
  end

  # return array of all kings currently in check
  def kings_in_check
    [@white_king, @black_king].select do |king|
      threats.include?(king.current_square)
    end
  end

  private

  # Return flat array of all threatened positions
  def threats
    Threat.new(@board).all_threats.values.flatten
  end

  ####
  # This came from Move
  # May need to reuse it
  # Maybe not
  ####

  # perform test move
  def moving_piece_resolves_check?(moving_piece)
    # move through each possible move in piece's movements
    moving_piece.possible_moves.each do |move|
      test_move = Move.new(@board, piece, @origin.relative_position(move))
      next unless test_move.valid?
      # for each movement made, check to see if the check? call is resolved
      next if test_move.players_king_in_check?
      # If the check is resolved, rewind the play and exit this method returning true - king is in check, not in check mate
      return true unless test_move.players_king_in_check?
      # If the check is not resolved, rewind the play and continue

      # If we get through all the piece's possible moves and the check isn't resolved, return false

      # Theoretically this should allow pieces to either block /or/ capture without having to
      # differentiate the tests
    end
  end
end
