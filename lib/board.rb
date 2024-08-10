# frozen_string_literal: true

require 'pry-byebug'

require_relative 'square'
require_relative 'position'
require_relative './pieces/pawn'
require_relative './pieces/rook'
require_relative './pieces/knight'
require_relative './pieces/bishop'
require_relative './pieces/queen'
require_relative './pieces/king'
require_relative 'move'

# This class represents a Chess Board
class Board
  attr_reader :en_passant, :en_passant_square, :en_passant_threat, :en_passant_square_opponent_will_occupy

  def initialize(clear: false)
    @squares = initialize_squares
    @piece_handler = Piece.new
    initialize_positions
    initialize_pieces unless clear
  end

  # return flat array of all squares
  def all_squares
    @squares.flatten
  end

  # return Array of Pieces
  def find_pieces_by_color(color)
    # expects +color+ = symbol or string
    all_squares.flat_map do |square|
      piece = get_piece(square.position)
      piece if piece&.color == color.to_sym
    end.to_a.compact
  end

  # Return a square object at a given location
  def get(square_name)
    return false unless on_board?(square_name.to_s.downcase)

    # expects +square_name+ = Position obj, string, or symbol (:a1..:h8)
    square_name = square_name.to_sym if square_name.instance_of?(Position)
    file_letter, rank_number = square_name.to_s.downcase.chars
    rank_index = rank_number.to_i - 1
    file_index = ('a'..'h').to_a.reverse.index(file_letter)
    @squares[file_index][rank_index]
  end

  # Return a piece object at a given location
  def get_piece(square_name)
    # expects +square_name+ = Position obj, string, or symbol (:a1..:h8)
    get(square_name).occupied? ? get(square_name).piece : nil
  end

  # move piece from square to square
  def move_piece(origin_square_name, target_square_name)
    # expects: +origin_square_name+ and +target_square_name+ : may be string
    #          or symbol :a1..:h8

    origin = get(origin_square_name).position
    target = get(target_square_name).position
    moving_piece = get_piece(origin.to_sym)

    # set up move for testing validity
    move = Move.new(self, moving_piece, target)

    if !moving_piece.is_a?(Knight)
      return false unless move.valid? && path_clear?(move)
    else
      return false unless move.valid?
    end

    # check for en passant
    set_en_passant(move) if en_passant?(move)

    # move piece
    if move.castle?
      king = remove_piece_from!(origin)
      rook = remove_piece_from!(move.get_castling_rook_square)
      put(king, target)
      put(rook, move.get_castling_rook_target_square)
      king.update
      rook.update
    else
      moving_piece = remove_piece_from!(origin)
      put(moving_piece, target)
      moving_piece.update
    end
  end

  # receive position object & evaluate true if on board, false if off
  def on_board?(position)
    # expects +position+ to be String, Symbol, or Position
    square_names_on_board = []
    ('a'..'h').to_a.each do |file|
      (1..8).to_a.each do |rank|
        square_names_on_board.push((file + rank.to_s).to_sym)
      end
    end

    square_names_on_board.include?(position.to_sym)
  end

  # return true if path empty, else return false
  def path_clear?(move_object)
    # expect +move_object+ to be a Move object
    walk_path(move_object).all? { |position| !get(position.to_sym).occupied? }
  end

  # place piece on specific square
  # TODO: Add error handling for passing invalid piece name (not object)
  # TODO: Add error handling for passing piece name (not object) and no color
  def put(piece_name, target, color = nil)
    if piece_name.is_a?(Piece)
      piece = piece_name
    else
      sanitized_piece_name = piece_name.to_s.downcase.to_sym
      piece = @piece_handler.create_piece(sanitized_piece_name, color)
    end

    piece.current_square = target.instance_of?(Position) ? target : get(target).position

    square = get(target)
    square.piece = piece
  end

  # Remove piece from square
  def remove_piece_from!(square_name)
    # this is a destructive method - it overwrites any data that exists on
    # Piece and Square
    # Expects:
    # - +square_name+ - string or symbol
    # returns piece object

    piece = get_piece(square_name.to_sym)
    return nil if piece.nil?

    piece.current_square = :tray

    square = get(square_name.to_sym)
    square.piece = nil

    piece
  end

  private

  # TODO: Migrate En Passant to its own Object
  # fill out en passant settings
  # the @en_passant_threat is going to be either an empty array or an array with 1-2 values.
  def set_en_passant(move)
    @en_passant = true
    @en_passant_square = move.destination
    @en_passant_threat = check_for_enemy_pawn_neighbors(move)
    @en_passant_square_opponent_will_occupy = calculate_occupiable_en_passant_square(move)
  end

  # TODO: Migrate En Passant to its own Object
  # check if current move is en_passant
  def en_passant?(move)
    return false unless move.piece.pawn?
    return false if move.piece.already_moved
    return false unless move.origin.file == move.destination.file
    return false unless (move.destination.rank.to_i - move.origin.rank.to_i).abs == 2
    return false if check_for_enemy_pawn_neighbors(move).empty?

    true
  end

  # TODO: Migrate En Passant to its own Object
  # return the square behind the pawn that moved
  def calculate_occupiable_en_passant_square(move)
    case move.piece.color
    when :black
      move.destination.relative_position(up: 1)
    when :white
      move.destination.relative_position(down: 1)
    end
  end

  # TODO: Migrate En Passant to its own Object
  # Check neighbors of destination square for an enemy pawn - purely for en passant
  def check_for_enemy_pawn_neighbors(move)
    left = move.destination.relative_position(left: 1)
    right = move.destination.relative_position(right: 1)

    left_neighbor = if on_board?(left) && !get_piece(left).nil?
                      get_piece(left)
                    else
                      false
                    end

    right_neighbor = if on_board?(right) && !get_piece(right).nil?
                       get_piece(right)
                     else
                       false
                     end

    results = []
    results << left_neighbor if left_neighbor && left_neighbor.pawn? && left_neighbor.color != move.piece.color

    results << right_neighbor if right_neighbor && right_neighbor.pawn? && right_neighbor.color != move.piece.color

    results
  end

  # return direction hash
  def directions(move_object)
    # expects +move_object+
    get_piece(move_object.origin).possible_moves.find do |move|
      move if move_object.origin.relative_position(**move) == move_object.destination
    end
  end

  # populate array with square objects
  def initialize_squares
    #  The following rules apply:
    #  - rank index even && file index even - black square.
    #  - rank index even && file index odd - white  square.
    #  - rank index odd && file index even - black square.
    #  - rank index odd && file index odd - white  square.
    array = Array.new(8) { Array.new(8) }
    array.each_with_index do |rank, rank_index|
      rank.each_index do |file_index|
        array[rank_index][file_index] = if rank_index.even? # Even rank index
                                          if file_index.even? # Even file index
                                            Square.new(:white)
                                          else # Odd file index
                                            Square.new(:black)
                                          end
                                        elsif file_index.odd? # Odd rank index
                                          Square.new(:white) # Odd file index
                                        else # Even file index
                                          Square.new(:black)
                                        end
        array[rank_index][file_index].rank = rank_index
        array[rank_index][file_index].file = file_index
      end
    end
  end

  # iterate through squares and return position object for each
  def initialize_positions
    ('a'..'h').to_a.each do |file|
      (1..8).each do |rank|
        name = (file + rank.to_s).to_sym
        get(name).position = Position.new(name)
      end
    end
  end

  # initialize Pieces on the board for play
  def initialize_pieces
    populate_rooks
    populate_knights
    populate_bishops
    populate_queens
    populate_kings
    populate_pawns
  end

  def populate_rooks
    %i[a1 h1].each { |square_name| put(:rook, square_name, :white) }
    %i[a8 h8].each { |square_name| put(:rook, square_name, :black) }
  end

  def populate_knights
    %i[b1 g1].each { |square_name| put(:knight, square_name, :white) }
    %i[b8 g8].each { |square_name| put(:knight, square_name, :black) }
  end

  def populate_bishops
    %i[c1 f1].each { |square_name| put(:bishop, square_name, :white) }
    %i[c8 f8].each { |square_name| put(:bishop, square_name, :black) }
  end

  def populate_queens
    put(:queen, :d1, :white)
    put(:queen, :d8, :black)
  end

  def populate_kings
    put(:king, :e1, :white)
    put(:king, :e8, :black)
  end

  def populate_pawns
    rank2 = ('a'..'h').to_a.map { |file| (file + 2.to_s).to_sym }
    rank7 = ('a'..'h').to_a.map { |file| (file + 7.to_s).to_sym }

    rank2.each { |square_name| put(:pawn, square_name, :white) }
    rank7.each { |square_name| put(:pawn, square_name, :black) }
  end

  # return an array of positions
  def walk_path(move_object)
    # expects +move_object+
    # don't need to rerun this every time
    dir = directions(move_object)
    path = []
    dir.flatten.find { |value| value.instance_of?(Integer) }.times do |n|
      tmp_directions = {}
      dir.each_key { |key| tmp_directions[key] = n + 1 }
      path.push(move_object.origin.relative_position(**tmp_directions))
    end
    path.map { |position| position unless position == move_object.destination }.compact
  end
end
