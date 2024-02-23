# frozen_string_literal: true

# This object handles threat calculation for chess
class Threat
  def initialize(board)
    @board = board
  end

  # return hash of all threatened positions, keyed by piece
  def all_threats
    squares_threatened_by_black_pieces.merge(squares_threatened_by_white_pieces)
  end

  # return hash of all positions threatened by black pieces
  def squares_threatened_by_black_pieces
    threat_by_color(:black)
  end

  # return hash of all squares threatened by white pieces
  def squares_threatened_by_white_pieces
    threat_by_color(:white)
  end

  private
  # return array of positions on board threatened by piece
  def get_squares_threatened_by_piece(piece)
    # expects +piece+ to be a Piece object
    piece.threatened_squares.map { |square| square if @board.on_board?(square) }.compact
  end

  # return hash of threatened squares
  def threat_by_color(color)
    # expects +color+ to be :black or :white
    chess_pieces = @board.find_pieces_by_color(color)
    threat_matrix = {}
    chess_pieces.each do |piece|
      threat_matrix[piece] = get_squares_threatened_by_piece(piece)
    end
    threat_matrix
  end
end
