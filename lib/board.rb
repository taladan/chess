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
  attr_reader :en_passant, :files, :file_labels, :ranks, :rank_labels, :squares

  def initialize(clear: false)
    @squares = Square.initialize_squares
    @piece_handler = Piece.new
    @en_passant = false
    @files = { a: %i[a1 a2 a3 a4 a5 a6 a7 a8], b: %i[b1 b2 b3 b4 b5 b6 b7 b8],
               c: %i[c1 c2 c3 c4 c5 c6 c7 c8], d: %i[d1 d2 d3 d4 d5 d6 d7 d8],
               e: %i[e1 e2 e3 e4 e5 e6 e7 e8], f: %i[f1 f2 f3 f4 f5 f6 f7 f8],
               g: %i[g1 g2 g3 g4 g5 g6 g7 g8], h: %i[h1 h2 h3 h4 h5 h6 h7 h8] }
    @file_labels = [' A  ', ' B ', '  C ', '  D  ', ' E ', '  F  ', ' G ', '  H ']
    @ranks = { one: %i[a1 b1 c1 d1 e1 f1 g1 h1], two: %i[a2 b2 c2 d2 e2 f2 g2 h2],
               three: %i[a3 b3 c3 d3 e3 f3 g3 h3], four: %i[a4 b4 c4 d4 e4 f4 g4 h4],
               five: %i[a5 b5 c5 d5 e5 f5 g5 h5], six: %i[a6 b6 c6 d6 e6 f6 g6 h6],
               seven: %i[a7 b7 c7 d7 e7 f7 g7 h7], eight: %i[a8 b8 c8 d8 e8 f8 g8 h8] }
    @rank_labels = { one: '1 ', two: '2 ', three: '3 ', four: '4 ', five: '5 ', six: '6 ', seven: '7 ', eight: '8 ' }

    Position.initialize_positions(self)
    Piece.initialize_pieces(self) unless clear
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
      raise InvalidMove, 'That is not a valid move' unless move.valid? && path_clear?(move)
    else
      raise InvalidMove, 'That is not a valid move' unless move.valid?
    end

    # check for en passant
    @en_passant = move.enpassant.en_passant? ? move.enpassant : false

    # move piece
    if move.castle?
      king = remove_piece_from!(origin)
      rook = remove_piece_from!(move.castling_rook_square)
      put(king, target)
      put(rook, move.castling_rook_target_square)
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
  def put(piece_name, target, color = nil)
    piece = piece_name.is_a?(Piece) ? piece_name : @piece_handler.create_piece(piece_name.to_s.downcase.to_sym, color)
    piece.current_square = target.instance_of?(Position) ? target : get(target).position
    get(target).piece = piece
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

  # return an array of positions
  def walk_path(move_object)
    # expects +move_object+
    # don't need to rerun this every time
    dir = move_object.directions
    path = []
    dir.flatten.find { |value| value.instance_of?(Integer) }.times do |n|
      tmp_directions = {}
      dir.each_key { |key| tmp_directions[key] = n + 1 }
      path.push(move_object.origin.relative_position(**tmp_directions))
    end
    path.map { |position| position unless position == move_object.destination }.compact
  end
end
