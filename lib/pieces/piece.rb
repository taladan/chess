# frozen_string_literal: true

# parent class for chess pieces
class Piece
  attr_reader :color
  attr_accessor :current_square

  def initialize(color = nil)
    @color = color
    @current_square = :tray
    @already_moved = false
  end

  # return array of possible moves
  def possible_moves
    []
  end

  # validate destination is within piece's possible moves
  def square_in_possible_moves?(destination)
    possible_moves.any? do |move|
      @current_square.relative_position(**move) == destination
    end
  end

  # return array of threatened positions
  def threatened_squares
    moves = []
    possible_moves.each do |move|
      moves.push({ move => @current_square.relative_position(**move) })
    end
    moves
  end

  def create_piece(type, color)
    case type
    when :pawn then Pawn.new(color)
    when :rook then Rook.new(color)
    when :knight then Knight.new(color)
    when :bishop then Bishop.new(color)
    when :queen then Queen.new(color)
    when :king then King.new(color)
    end
  end

  def pawn?
    instance_of?(Pawn)
  end

  def king?
    instance_of?(King)
  end

  def knight?
    instance_of?(Knight)
  end

  def rook?
    instance_of?(Rook)
  end

  def update
    @already_moved = true
  end

  # has the piece moved at least once?
  def has_moved?
    @already_moved
  end

  # initialize Pieces on the board for play
  def self.initialize_pieces(board_object)
    populate_rooks(board_object)
    populate_knights(board_object)
    populate_bishops(board_object)
    populate_queens(board_object)
    populate_kings(board_object)
    populate_pawns(board_object)
  end

  def self.populate_rooks(board_object)
    %i[a1 h1].each { |square_name| board_object.put(:rook, square_name, :white) }
    %i[a8 h8].each { |square_name| board_object.put(:rook, square_name, :black) }
  end

  def self.populate_knights(board_object)
    %i[b1 g1].each { |square_name| board_object.put(:knight, square_name, :white) }
    %i[b8 g8].each { |square_name| board_object.put(:knight, square_name, :black) }
  end

  def self.populate_bishops(board_object)
    %i[c1 f1].each { |square_name| board_object.put(:bishop, square_name, :white) }
    %i[c8 f8].each { |square_name| board_object.put(:bishop, square_name, :black) }
  end

  def self.populate_queens(board_object)
    board_object.put(:queen, :d1, :white)
    board_object.put(:queen, :d8, :black)
  end

  def self.populate_kings(board_object)
    board_object.put(:king, :e1, :white)
    board_object.put(:king, :e8, :black)
  end

  def self.populate_pawns(board_object)
    rank2 = ('a'..'h').to_a.map { |file| (file + 2.to_s).to_sym }
    rank7 = ('a'..'h').to_a.map { |file| (file + 7.to_s).to_sym }

    rank2.each { |square_name| board_object.put(:pawn, square_name, :white) }
    rank7.each { |square_name| board_object.put(:pawn, square_name, :black) }
  end
end
