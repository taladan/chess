# frozen_string_literal: true

require 'pry-byebug'

require_relative 'square'
require_relative './pieces/pawn.rb'
require_relative './pieces/rook.rb'
require_relative './pieces/knight.rb'
require_relative './pieces/bishop.rb'
require_relative './pieces/queen.rb'
require_relative './pieces/king.rb'

# responsibilities include:
# - Initializing square objects into an accessible data 
#   structures for game board
# - Square handling
class Board
  def initialize
    # array of square objects representing the chess board
    @squares = initialize_squares
    initialize_pieces
  end

  # Return a square object at a given location
  # expects string or symbol :a1..:h8
  def get(square_name)
    rank_letter, file_number = square_name.to_s.downcase.chars
    rank_index = ('a'..'h').to_a.reverse.index(rank_letter)
    file_index = file_number.to_i - 1
    @squares[rank_index][file_index]
  end

  # move piece from square to square
  # expects string or symbol :a1..:h8
  def move(from_square_name, to_square_name)
    # get squares
    from_square = get(from_square_name)
    to_square = get(to_square_name)

    # get piece
    piece = from_square.piece
    
    can_move?(piece, to_square)

    # move piece
    to_square.piece = piece
    piece.current_square = to_square_name
  end

  private

  # set up board then set up pieces
  def initialize_board
    initialize_squares
    initialize_pieces
  end

  # populate array with square objects
  # for a chess board, the top left square from the white position (h1)
  # is always white.  Chess boards alternate white/black/white/black.
  #  The following rules apply:
  #  - rank index even && file index even - black square.
  #  - rank index even && file index odd - white  square.
  #  - rank index odd && file index even - black square.
  #  - rank index odd && file index odd - white  square.
  def initialize_squares
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
      end
    end
  end

  # Initialize Pieces on the board for play.
  def initialize_pieces
    populate_rooks
    populate_knights
    populate_bishops
    populate_queens
    populate_kings
    populate_pawns
  end

  # populate rooks
  def populate_rooks
    [:a1, :h1].each do |square_name|
      piece = Rook.new(:white)
      piece.current_square = square_name
      square = get(square_name)
      square.piece = piece
    end

    [:a8, :h8].each do |square_name|
      piece = Rook.new(:black)
      piece.current_square = square_name
      square = get(square_name)
      square.piece = piece
    end
  end

  # populate knights
  def populate_knights
    [:b1, :g1].each do |square_name|
      piece = Knight.new(:white)
      piece.current_square = square_name
      square = get(square_name)
      square.piece = piece
    end

    [:b8, :g8].each do |square_name|
      piece = Knight.new(:black)
      piece.current_square = square_name
      square = get(square_name)
      square.piece = piece
    end
  end

  # populate bishops
  def populate_bishops
    [:c1, :f1].each do |square_name|
      piece = Bishop.new(:white)
      piece.current_square = square_name
      square = get(square_name)
      square.piece = piece
    end

    [:c8, :f8].each do |square_name|
      piece = Bishop.new(:black)
      piece.current_square = square_name
      square = get(square_name)
      square.piece = piece
    end
  end

  # populate queens
  def populate_queens
    white_queen = Queen.new(:white)
    white_queen.current_square = :d1
    wq_square = get(:d1)
    wq_square.piece = white_queen

    black_queen = Queen.new(:black)
    black_queen.current_square = :d8
    bq_square = get(:d8)
    bq_square.piece = black_queen
  end

  # populate kings
  def populate_kings
    white_king = King.new(:white)
    white_king.current_square = :e1
    wk_square = get(:e1)
    wk_square.piece = white_king

    black_king = King.new(:black)
    black_king.current_square = :e8
    bk_square = get(:e8)
    bk_square.piece = black_king
  end

  # populate pawns
  def populate_pawns
    rank2 = ('a'..'h').to_a.map { |file| (file + 2.to_s).to_sym }
    rank7 = ('a'..'h').to_a.map { |file| (file + 7.to_s).to_sym }

    rank2.each do |square_name|
      piece = Pawn.new(:white)
      piece.current_square = square_name
      square = get(square_name)
      square.piece = piece
    end

    rank7.each do |square_name|
      piece = Pawn.new(:black)
      piece.current_square = square_name
      square = get(square_name)
      square.piece = piece
    end
  end
end
