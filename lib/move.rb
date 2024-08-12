# frozen_string_literal: true

require_relative 'threat'
require_relative 'castle'
require_relative 'enpassant'

# Move - encompasses the logic of movement
class Move
  attr_reader :board, :destination, :origin, :piece, :threats, :castling_rook_target_square, :castling_rook_square,
              :enpassant

  def initialize(board, piece, destination)
    @board = board
    @destination = convert_to_position(destination)
    @piece = piece.is_a?(Piece) ? piece : @board.get_piece(piece)
    @origin = board.get(@piece.current_square).position
    @threats = calculate_threats
    @attack = @board.get(@destination).occupied?
    @enpassant = EnPassant.new(self)
  end

  # validate piece movement
  def valid?
    return false unless piece.square_in_possible_moves?(@destination)

    return false unless can_move_to?

    @board.path_clear?(self) unless @piece.knight?

    does_not_threaten_moving_players_king?
  end

  # Check the move to see if it qualifies as a castle maneuver
  def castle?
    castle = Castle.new(self)

    # return the target square of the rook involved in the castle maneuver
    @castling_rook_target_square = castle.get_skipped_square_for_castling_king
    @castling_rook_square = castle.get_castling_rook_square
    castle.check_move
  end

  # return direction hash
  def directions
    # expects +move_object+
    @piece.possible_moves.find do |move|
      move if @origin.relative_position(**move) == @destination
    end
  end


  private

  ####
  # Instance variable calculations
  ####

  # return threat hash based on color of the piece that is moving
  def calculate_threats
    threat_object = Threat.new(@board)
    case @piece.color
    when :white
      threat_object.squares_threatened_by_black_pieces
    when :black
      threat_object.squares_threatened_by_white_pieces
    end
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
    if @origin.file != square.position.file
      square.occupied? && @piece.color != square.piece.color
    else
      !square.occupied?
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

    calculate_threats.each_value do |value|
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

  # return square object
  def find_players_king
    color = @piece.color == :white ? :white : :black
    @board.find_pieces_by_color(color).select(&:king?)[0].current_square
  end
end
