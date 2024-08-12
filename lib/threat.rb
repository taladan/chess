# frozen_string_literal: true

# This object handles threat calculation for chess
class Threat
  def initialize(board)
    @board = board
  end

  # return hash of all threatened positions, keyed by piece
  def all_threats(attack = true)
    # optional +attack+ argument accepted must be true or false
    @attack = attack
    squares_threatened_by_black_pieces(@attack).merge(squares_threatened_by_white_pieces(@attack))
  end

  # return hash of all positions threatened by black pieces
  def squares_threatened_by_black_pieces(attack = true)
    # optional +attack+ argument accepted must be true or false
    @attack = attack
    threat_by_color(:black)
  end

  # return hash of all squares threatened by white pieces
  def squares_threatened_by_white_pieces(attack = true)
    # optional +attack+ argument accepted must be true or false
    @attack = attack
    threat_by_color(:white)
  end

  private

  # return array of positions on board threatened by piece
  def get_squares_threatened_by_piece(piece)
    # expects +piece+ to be a Piece object
    blocked_directions = []
    threats = []
    piece.threatened_squares.map do |movement|
      square = movement.values.pop
      # skip our own square
      next if square == piece.current_square

      move = movement.keys.pop
      # Is this direction already blocked?
      next if blocked_directions.include?(move.keys)

      # Block this direction and skip if it's not even on the board
      unless @board.on_board?(square)
        blocked_directions.push(move.keys)
        next
      end

      # Square's empty?  Threatenable!

      if @board.get_piece(square).nil?
        threats.push(square)
        next
      end

      # Enemy piece?  Threatenable but blocks further travel in this direction
      if square_has_enemy_piece?(piece, square)
        blocked_directions.push(move.keys)
        threats.push(square)
        next
      # Player's piece? block this direction and skip
      elsif square_has_players_piece?(piece, square)
        blocked_directions.push(move.keys)
        next
      end
    end.compact
    threats
  end

  # returns boolean
  def square_has_enemy_piece?(piece, square)
    case piece.color
    when :white
      @board.get_piece(square).color == :black
    when :black
      @board.get_piece(square).color == :white
    end
  end

  # returns boolean
  def square_has_players_piece?(piece, square)
    case piece.color
    when :white
      @board.get_piece(square).color == :white
    when :black
      @board.get_piece(square).color == :black
    end
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
