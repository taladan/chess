# frozen_string_literal: true

require 'pry-byebug'

require_relative 'square'
require_relative 'position'
require_relative './pieces/pawn'
require_relative './pieces/rook.rb'
require_relative './pieces/knight.rb'
require_relative './pieces/bishop.rb'
require_relative './pieces/queen.rb'
require_relative './pieces/king.rb'
require_relative 'threat'

# This class represents a Chess Board
class Board
  attr_reader :threats

  def initialize
    @squares = initialize_squares
    @piece_handler = Piece.new
    initialize_positions
    initialize_pieces
    @threats = Threat.new(self)
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
    # expects +square_name+ = Position obj, string, or symbol (:a1..:h8)
    square_name = square_name.to_sym if square_name.instance_of?(Position)
    rank_letter, file_number = square_name.to_s.downcase.chars
    rank_index = ('a'..'h').to_a.reverse.index(rank_letter)
    file_index = file_number.to_i - 1
    @squares[rank_index][file_index]
  end

  # Return a piece object at a given location
  def get_piece(square_name)
    # expects +square_name+ = Position obj, string, or symbol (:a1..:h8)
    get(square_name).occupied? ? get(square_name).piece : nil
  end

  # move piece from square to square
  # TODO: finish this
  def move_piece(origin_square_name, target_square_name)
    # expects: +origin_square_name+ and +target_square_name+ : may be string
    #          or symbol :a1..:h8

    origin = get(origin_square_name).position
    target = get(target_square_name).position
    moving_piece = get_piece(origin.to_sym)

    # set up move for testing validity
    move = Move.new(self, moving_piece, target)

    return nil unless move.valid?

    # move piece
    moving_piece = remove_piece_from!(origin)
    put(moving_piece, target)
    moving_piece.update
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
    path = walk_path(move_object)
    path.all? { |position| !get(position.to_sym).occupied? }
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

  # return direction hash
  def directions_from_piece(move_object)
    # expects +move_object+
    get_piece(move_object.origin).possible_moves.select do |move|
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
    array = Array.new(8) {Array.new(8)}
    array.each_with_index do |rank, rank_index|
      rank.each_index do |file_index|
        if rank_index.even? # Even rank index
          if file_index.even? # Even file index
            array[rank_index][file_index] = Square.new(:white)
          else # Odd file index
            array[rank_index][file_index] = Square.new(:black)
          end
        else # Odd rank index
          if file_index.odd? # Odd file index
            array[rank_index][file_index] = Square.new(:white)
          else # Even file index
            array[rank_index][file_index] = Square.new(:black)
          end
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

  # return opponent's color
  def opponent_color(piece)
    # expects +piece+
    case piece.color
    when :white
      :black
    when :black
      :white
    end
  end

  # return Array of opponent's pieces
  def opponent_pieces(color)
    # expects +piece+ to be :black or :white
    case color
    when :white
      find_pieces_by_color(:black)
    when :black
      find_pieces_by_color(:white)
    end
  end

  # TODO: refactor populate methods to use #put in order to DRY up code
  def populate_rooks
    [:a1, :h1].each do |square_name|
      piece = @piece_handler.create_piece(:rook, :white)
      piece.current_square = Position.new(square_name)
      square = get(square_name)
      square.piece = piece
    end

    [:a8, :h8].each do |square_name|
      piece = @piece_handler.create_piece(:rook, :black)
      piece.current_square = Position.new(square_name)
      square = get(square_name)
      square.piece = piece
    end
  end

  def populate_knights
    [:b1, :g1].each do |square_name|
      piece = @piece_handler.create_piece(:knight, :white)
      piece.current_square = Position.new(square_name)
      square = get(square_name)
      square.piece = piece
    end

    [:b8, :g8].each do |square_name|
      piece = @piece_handler.create_piece(:knight, :black)
      piece.current_square = Position.new(square_name)
      square = get(square_name)
      square.piece = piece
    end
  end

  def populate_bishops
    [:c1, :f1].each do |square_name|
      piece = @piece_handler.create_piece(:bishop, :white)
      piece.current_square = Position.new(square_name)
      square = get(square_name)
      square.piece = piece
    end

    [:c8, :f8].each do |square_name|
      piece = @piece_handler.create_piece(:bishop, :black)
      piece.current_square = Position.new(square_name)
      square = get(square_name)
      square.piece = piece
    end
  end

  def populate_queens
    white_queen = @piece_handler.create_piece(:queen, :white)
    white_queen.current_square = Position.new(:d1)
    wq_square = get(:d1)
    wq_square.piece = white_queen

    black_queen = @piece_handler.create_piece(:queen, :black)
    black_queen.current_square = Position.new(:d8)
    bq_square = get(:d8)
    bq_square.piece = black_queen
  end

  def populate_kings
    white_king = @piece_handler.create_piece(:king, :white)
    white_king.current_square = Position.new(:e1)
    wk_square = get(:e1)
    wk_square.piece = white_king

    black_king = @piece_handler.create_piece(:king, :black)
    black_king.current_square = Position.new(:e8)
    bk_square = get(:e8)
    bk_square.piece = black_king
  end

  def populate_pawns
    rank2 = ('a'..'h').to_a.map { |file| (file + 2.to_s).to_sym }
    rank7 = ('a'..'h').to_a.map { |file| (file + 7.to_s).to_sym }

    rank2.each do |square_name|
      piece = @piece_handler.create_piece(:pawn, :white)
      piece.current_square = Position.new(square_name)
      square = get(square_name)
      square.piece = piece
    end

    rank7.each do |square_name|
      piece = @piece_handler.create_piece(:pawn, :black)
      piece.current_square = Position.new(square_name)
      square = get(square_name)
      square.piece = piece
    end
  end

  # return an array of positions
  def walk_path(move_object)
    # expects +move_object+
    directions = directions_from_piece(move_object)[0]
    path = []
    directions.flatten.find { |value| value.instance_of?(Integer) }.times do |n|
      tmp_directions = {}
      directions.each_key { |key| tmp_directions[key] = n + 1 }
      path.push(move_object.origin.relative_position(**tmp_directions))
    end
    path.map { |position| position unless position == move_object.destination }.compact
  end
end
