# frozen_string_literal: true

# Move - encompasses the logic of movement
class Move
  attr_reader :board, :destination, :origin, :piece, :threats

  def initialize(board, piece, destination)
    @board = board
    @destination = convert_to_position(destination)
    @piece = assign_piece(piece)
    @origin = board.get(@piece.current_square).position
    @threats = calculate_threats
    @attack = @board.get(@destination).occupied?
  end

  # validate piece movement
  def valid?
    return false unless piece_has_square_in_possible_moves?

    return false unless can_move_to?

    @board.path_clear?(self) unless @piece.knight?

    does_not_threaten_moving_players_king?
  end

  private

  ####
  # Instance variable calculations
  ####

  # return threat hash based on color of the piece that is moving
  def calculate_threats
    case @piece.color
    when :white
      @board.threats.squares_threatened_by_black_pieces
    when :black
      @board.threats.squares_threatened_by_white_pieces
    end
  end

  # returns Piece object
  def assign_piece(piece)
    # expects +piece+ to be either Piece object, string or symbol
    return piece if piece.is_a?(Piece)

    @board.get_piece(piece)
  end

  ####
  # Movement validation section
  ####

  # validate destination is valid and occupiable
  def can_move_to?
    # @origin.relative_position(@destination)
    square = @board.get(@destination.to_sym)
    if @piece.pawn?
      pawn_can_move_to?
    elsif square.occupied?
      @piece.color != square.piece.color
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
    if @origin.y != square.position.y
      square.occupied? && @piece.color != square.piece.color
    else
      !square.occupied?
    end
  end

  # validate destination is within piece's possible moves
  def piece_has_square_in_possible_moves?
    @piece.possible_moves.any? do |move|
      @origin.relative_position(**move) == @destination
    end
  end

####
# Threat
####
  # return false if planned move threatens moving player's king
  def does_not_threaten_moving_players_king?
    moving_piece = @board.remove_piece_from!(@origin)
    destination_piece = @board.remove_piece_from!(@destination)

    @board.put(moving_piece, @destination)
    king_position = find_players_king
    output = nil

    threats.each_value do |value|
      value.each do |position|
        next if output == false

        output = position != king_position
      end
    end

    @board.remove_piece_from!(@destination)
    @board.put(moving_piece, @origin)
    @board.put(destination_piece, @destination) unless destination_piece.nil?
    output
  end

  def find_players_king
    color = @piece.color == :white ? :white : :black
    @board.find_pieces_by_color(color).select(&:king?)[0].current_square
  end
end
