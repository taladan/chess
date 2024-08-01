# frozen_string_literal: true

require_relative 'threat'

# Move - encompasses the logic of movement
class Move
  attr_reader :board, :destination, :origin, :piece

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

  # Check the move to see if it qualifies as a castle maneuver
  def castle?
    # Castling requires that the following rules are true:
    # - must be a king moving
    # - must be in the same rank (lateral movement only)
    # - must be a movement of exactly 2 spaces
    # - can't have already moved
    # - can't if rook in that direction has already moved
    # - can't if king is in check at origin
    # - can't if destination is threatened
    # - can't if movement path is threatened

    piece.king? &&
      origin.rank == destination.rank &&
      (origin.file.to_s.ord - destination.file.to_s.ord).abs == 2 &&
      !piece.has_moved? &&
      !rook_has_moved? &&
      !piece_threatened? &&
      !destination_threatened? &&
      !path_threatened?
  end

  # return the rook piece the king is castling toward
  def get_castling_rook_square
    rook_square
  end

  # return the target square of the rook involved in the castle maneuver
  def get_castling_rook_target_square
    get_skipped_square_for_castling_king
  end

  private

  ###
  # Castling methods
  ###

  # returns boolean
  def piece_threatened?
    # @threats.include?(origin)
    square_threatened?(origin)
  end

  # returns boolean
  def destination_threatened?
    # @threats.include?(destination)
    square_threatened?(destination)
  end

  # returns boolean
  def path_threatened?
    square_threatened?(get_skipped_square_for_castling_king)
  end

  # return a symbol name of square the king passes over in castle maneuver
  def get_skipped_square_for_castling_king
    case get_direction_of_lateral_movement
    when :left
      target = board.get(:d1).position if piece.color == :white
      target = board.get(:d8).position if piece.color == :black
    when :right
      target = board.get(:f1).position if piece.color == :white
      target = board.get(:f8).position if piece.color == :black
    end
    target
  end

  # return boolean
  def square_threatened?(square_position)
    # expects a +square_position+ to be a position object
    @threats.each_value.each.to_a.flatten.include?(square_position)
  end

  # returns a boolean
  def rook_has_moved?
    return true if rook_square_empty?

    piece_in_rook_square = board.get_piece(rook_square)
    return true unless piece_in_rook_square.rook? && piece_in_rook_square.color == piece.color

    piece_in_rook_square.has_moved?
  end

  def rook_square_empty?
    # if the square is occupied, send false (not empty)
    !board.get(rook_square).occupied?
  end

  # get the name of the rook's square depending on king's lateral movement
  def rook_square
    case get_direction_of_lateral_movement
    when :left
      target_square = :a1 if piece.color == :white
      target_square = :a8 if piece.color == :black
    when :right
      target_square = :h1 if piece.color == :white
      target_square = :h8 if piece.color == :black
    end
    target_square
  end

  # return :left or :right
  def get_direction_of_lateral_movement
    direction = :left if origin.file > destination.file
    direction = :right if origin.file < destination.file
    direction
  end

  # return :up or :down
  # This is not used yet, but might become useful in the future, came about as a completion to #get_direction_of_lateral_movement
  # For now I'm leaving this in the Castling section
  def get_direction_of_vertical_movement
    :up if origin.rank < destination.rank
    :down if origin.rank > destination.rank
  end

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
    if @origin.file != square.position.file
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

  def find_players_king
    color = @piece.color == :white ? :white : :black
    @board.find_pieces_by_color(color).select(&:king?)[0].current_square
  end
end
