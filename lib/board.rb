# frozen_string_literal: true

require 'pry-byebug'

require_relative 'square'
require_relative "position"
require_relative './pieces/pawn'
require_relative './pieces/rook.rb'
require_relative './pieces/knight.rb'
require_relative './pieces/bishop.rb'
require_relative './pieces/queen.rb'
require_relative './pieces/king.rb'

# This class represents a Chess Board
class Board
  def initialize
    @squares = initialize_squares
    @piece_handler = Piece.new
    initialize_positions
    initialize_pieces
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
    end.compact
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
    get(square_name).piece
  end

  # move piece from square to squar
  # TODO: finish this
  def move(from_square_name, to_square_name)
    # TODO: finish this when Move is functioning
    # expects string or symbol :a1..:h8
    # Right now I am not going to worry about validation of 'is this a square on
    # the board?' type issues - that's what valid_move? is going to take care of.
    # This function is going to be doing too much to begin with.

    from_square = get(from_square_name)
    to_square = get(to_square_name)

    piece = from_square.piece

    # valid_move?(piece, to_square)
    # Move validation goes here

    # move piece
    to_square.piece = piece
    piece.current_square = Position.new(to_square_name)
    from_square.piece = nil
  end

  # is the requested move in the selected piece's possible_moves
  # Can the square be occupied
  # does the move create a threat?
  # TODO: Pull this out and modify when Move is in
  def valid_move?(piece, from_square, to_square)
    destination_in_piece_moves?(piece, to_square)
    can_occupy?(piece, to_square)
    !creates_threat?(piece, from_square, to_square)
  end

  # receive position object & evaluate true if on board, false if off
  def on_board?(position)
    bd = []
    ('a'..'h').to_a.each do |file|
      (1..8).to_a.each do |rank|
        bd.push((file + rank.to_s).to_sym)
      end
    end

    bd.include?(position.to_sym)
  end

  # place piece on specific square
  def put(piece_name, square_name, color = nil)
    # This is a destructive method - it overwrites any piece on the square
    # expects:
    # - +piece+  - Piece object or string or symbol of piece name
    #   using string or symbol creates a new piece on the square
    # - +square+ - string or symbol
    # - +color+ (optional) - :white or :black
    #   Note: If you do not include a color and are using this to create a piece
    #   instead of placing an existing piece it will be colorless and
    #   render incorrectly.
    if piece_name.is_a?(Piece)
      piece = piece_name
    else
      sanitized_piece_name = piece_name.to_s.downcase.to_sym
      piece = @piece_handler.create_piece(sanitized_piece_name, color)
    end
    piece.current_square = Position.new(square_name.to_sym)
    square = get(square_name)
    square.piece = piece
  end

  # Remove piece from square
  def remove_piece_from(square_name)
    # this is a destructive method - it overwrites any data that exists on
    # Piece and Square
    # Expects:
    # - +square_name+ - string or symbol
    # returns piece object
    square = get(square_name.to_sym)

    piece = square.piece

    piece.current_square = :tray

    square.piece = nil

    piece
  end

  private

  # populate array with square objects
  def initialize_squares
    # for a chess board, the top left square from the white position (h1)
    # is always white.  Chess boards alternate white/black/white/black.
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
end
