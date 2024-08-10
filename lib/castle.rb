# frozen_string_literal: true

# Utilities for determining castle state and position
class Castle
  def initialize(move)
    @board = move.board
    @destination = move.destination
    @origin = move.origin
    @piece = move.piece
    @threats = move.threats
  end

  # return boolean validation of castle state
  def check_move
    @piece.king? &&
      @origin.rank == @destination.rank &&
      (@origin.file.to_s.ord - @destination.file.to_s.ord).abs == 2 &&
      !@piece.has_moved? &&
      !rook_has_moved? &&
      !piece_threatened? &&
      !destination_threatened? &&
      !path_threatened?
  end

  # return a symbol name of the rook's square depending on king's lateral movement
  def get_castling_rook_square
    case direction_of_lateral_movement
    when :left
      target_square = :a1 if @piece.color == :white
      target_square = :a8 if @piece.color == :black
    when :right
      target_square = :h1 if @piece.color == :white
      target_square = :h8 if @piece.color == :black
    end
    target_square
  end

  # return a symbol name of square the king passes over in castle maneuver
  def get_skipped_square_for_castling_king
    case direction_of_lateral_movement
    when :left
      target = @board.get(:d1).position if @piece.color == :white
      target = @board.get(:d8).position if @piece.color == :black
    when :right
      target = @board.get(:f1).position if @piece.color == :white
      target = @board.get(:f8).position if @piece.color == :black
    end
    target
  end

  private

  ###
  # Rook Stuff
  ###

  # returns a boolean
  def rook_has_moved?
    return true unless @board.get(get_castling_rook_square).occupied?

    piece_in_rook_square = @board.get_piece(get_castling_rook_square)
    return true unless piece_in_rook_square.rook? && piece_in_rook_square.color == @piece.color

    piece_in_rook_square.has_moved?
  end

  ####
  # Threat
  ####

  # returns boolean
  def piece_threatened?
    square_threatened?(@origin)
  end

  # returns boolean
  def destination_threatened?
    square_threatened?(@destination)
  end

  # returns boolean
  def path_threatened?
    square_threatened?(get_skipped_square_for_castling_king)
  end

  # return boolean - expects a +square_position+ to be a position object
  def square_threatened?(square_position)
    @threats.each_value.each.to_a.flatten.include?(square_position)
  end

  # return :left or :right
  def direction_of_lateral_movement
    direction = :left if @origin.file > @destination.file
    direction = :right if @origin.file < @destination.file
    direction
  end
end
