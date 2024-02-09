# frozen_string_literal: true

# work with positions only -  pull squares only when necessary
# Move - encompasses the logic of movement
class Move
  def initialize(board, piece, destination)
    @board = board
    @piece = piece
    @origin = board.get(piece.current_square).position
    @destination = convert_to_position(destination)
  end

  def valid?
    can_move_to?(destination)
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
  def can_move_to?(position)
    square = @board.get(position.to_sym)
    if @piece.is_pawn?
      pawn_can_move_to?(position)
    elsif square.occupied?
      @piece.color != square.piece.color
    else
      true
    end
  end

  # pawns have special movement rules
  # expects Position object
  # return true || false
  def pawn_can_move_to?(position)
    square = @board.get(position.to_sym)
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
    false
  end

  # Check that if square is occupied, it's occupied by an enemy piece
  # if it's empty or occupied by an enemy piece, it's occupiable
  def can_occupy?(position)
    square = @board.get(position.to_sym)
    if square.occupied?
      square.piece.color != @piece.color
    else
      true
    end
  end
end
