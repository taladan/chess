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

  # validate clear path
  def path_clear?
    path = path_from_piece[0]
    path.flatten.find { |value| value.instance_of?(Integer) }.times do |n|
      tmp_directions = {}
      path.each_key { |key| tmp_directions[key] = n + 1 }
      return @board.get_piece(@origin.relative_position(**tmp_directions)).nil?
    end
  end

  # return the path from @piece that matches the movement
  # from @origin to @destination
  def path_from_piece
    @piece.possible_moves.select do |move|
      move if @origin.relative_position(**move) == @destination
    end
  end

  # return Array of opponent's pieces
  def opponent_pieces
    case @piece.color
    when :white
      @board.find_pieces_by_color(:black)
    when :black
      @board.find_pieces_by_color(:white)
    end
  end

  # TODO: Workout current issue:
  #       Currently this function only calculates whether a square/position
  #       is in the set of possible_moves of a piece - it doesn't actually run
  #       the checks to see if the piece can move through its path to that spot
  def threatens_players_king?
    player_king_position = @board.find_pieces_by_color(@piece.color).select do |piece|
      piece.king?
    end[0].current_square

    opponent_pieces.any? do |piece|
      piece.possible_moves.any? do |move|
        test_position = piece.current_square.relative_position(**move)
        if test_position == player_king_position
          Move.new(@board, piece, test_position).path_clear?
        end
      end
    end
  end

  # TODO: Flesh out calculating opponent threat calculation
  def threatens_opponents_king?

  end

  # validate piece movement
  def valid?
    piece_has_square_in_possible_moves?
    can_move_to?
    path_clear? unless @piece.knight?
    !threatens_players_king?
  end

  private

  # validate destination is valid and occupiable
  def can_move_to?
    @origin.relative_position(@destination)
    square = @board.get(@destination.to_sym)
    if @piece.pawn?
      pawn_can_move_to?
    elsif square.occupied?
      @piece.color != square.piece.color
    else
      true
    end
  end

  # validate that piece can occupy square
  def can_occupy?
    square = @board.get(@destination.to_sym)
    if square.occupied?
      square.piece.color != @piece.color
    else
      true
    end
  end

  # convert a symbol to a position
  def convert_to_position(dest)
    # expect: +dest+ of either symbol or Position object.
    return dest if dest.instance_of?(Position)

    @board.get(dest).position if dest.is_a?(Square) ||
                                 dest.is_a?(Symbol) ||
                                 dest.is_a?(String)
  end

  # validate special pawn movement
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

  # validate destination is within piece's possible moves
  def piece_has_square_in_possible_moves?
    @piece.possible_moves.any? do |move|
      @origin.relative_position(**move) == @destination
    end
  end
end
