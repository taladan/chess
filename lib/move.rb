# frozen_string_literal: true

# Move - encompasses the logic of movement
class Move
  attr_reader :origin, :destination

  def initialize(board, piece, destination)
    @board = board
    @piece = piece
    @origin = board.get(piece.current_square).position
    @destination = convert_to_position(destination)
  end

  # TODO: Need to walk path of piece and check for obstacles, unless piece is a knight

  def valid?
    piece_has_square_in_possible_moves?
    can_move_to?
    if !path_empty?
      check_pieces_in_path != piece.color
    end
  end

  # return hash of positions
  def path
    # iterate piece movements and pull the set of directions that
    # lands the piece on the destination from origin
    directions = @piece.possible_moves.any? do |move|
      current_position = @origin.relative_position(**move)
      @board.on_board?(current_position) &&
        can_move_to?(current_position)
    end
    # once a set of directions is established, generate a position
    # from each step, Collect a hash of
  end

  def threatens_opponent?

  end

  def create_threat_for_moving_side?

  end

  def convert_to_position(dest)
    dest if dest.is_a?(Position)

    if dest.is_a?(Square) || dest.is_a?(Symbol) || dest.is_a?(String)
      @board.get(dest).position
    end
  end

  # can the piece move to the square
  def can_move_to?
    @origin.relative_position(@destination)
    square = @board.get(@destination.to_sym)
    if @piece.is_pawn?
      pawn_can_move_to?
    elsif square.occupied?
      @piece.color != square.piece.color
    else
      true
    end
  end

  # pawns have special movement rules
  # expects Position object
  # return true || false
  def pawn_can_move_to?
    square = @board.get(@destination.to_sym)
    if @origin.y != position.y
      square.occupied? && @piece.color != square.piece.color
    elsif square.occupied?
      @piece.color != square.piece.color
    else
      true
    end
  end

  # does this movement create a threat for either king
  def creates_threat?
    # TODO: figure out how to run threats
    false
  end

  # return true if piece can occupy square, false if not
  def can_occupy?
    square = @board.get(@destination.to_sym)
    if square.occupied?
      square.piece.color != @piece.color
    else
      true
    end
  end

  private

  def piece_has_square_in_possible_moves?
    @piece.possible_moves.any? do |move|
      @origin.relative_position(**move) == @destination
    end
  end
end
