# frozen_string_literal: true

# This object handles threat calculation for chess
class Threat
  def initialize(board)
    @board = board
  end

  # return hash of all threatened positions, keyed by piece
  def all_threats(attack=true)
    # optional +attack+ argument accepted must be true or false
    @attack = attack
    squares_threatened_by_black_pieces(@attack).merge(squares_threatened_by_white_pieces(@attack))
  end

  # return hash of all positions threatened by black pieces
  def squares_threatened_by_black_pieces(attack=true)
    # optional +attack+ argument accepted must be true or false
    @attack = attack
    threat_by_color(:black)
  end

  # return hash of all squares threatened by white pieces
  def squares_threatened_by_white_pieces(attack=true)
    # optional +attack+ argument accepted must be true or false
    @attack = attack
    threat_by_color(:white)
  end

  private

  # return array of positions on board threatened by piece
  def get_squares_threatened_by_piece(piece)
    # expects +piece+ to be a Piece object
    threatened_squares(piece).map do |square|
      square if @board.on_board?(square)
    end.compact
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

  # return array of threatened positions
  def threatened_squares(piece)
    return pawn_threats(piece) if piece.pawn? && @attack

    moves = []
    piece.possible_moves.each do |move|
      moves.push(piece.current_square.relative_position(**move))
    end
    moves
  end

  # remove vertical moves and return array of threatened positions
  def pawn_threats(piece)
    # code here
    moves = []
    piece.possible_moves.each do |move|
      next if move.length == 1

      moves.push(piece.current_square.relative_position(**move))
    end
    moves
  end
end
