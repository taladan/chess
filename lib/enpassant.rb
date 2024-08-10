# frozen_string_literal: true

# Validates en passant movements
class EnPassant
  attr_reader :en_passant, :square, :threat, :opponent_target_square

  def initialize(move_object)
    @move = move_object
    @en_passant = false
    @square = nil
    @threat = nil
    @opponent_target_square = nil
    set_en_passant if en_passant?
  end

  # fill out en passant settings
  # the @en_passant_threat is going to be either an empty array or an array with 1-2 values.
  def set_en_passant
    @en_passant = true
    @square = @move.destination
    @threat = check_for_enemy_pawn_neighbors
    @opponent_target_square = calculate_occupiable_en_passant_square
  end

  # check if current move is en_passant
  def en_passant?
    return false unless @move.piece.pawn?
    return false if @move.piece.already_moved
    return false unless @move.origin.file == @move.destination.file
    return false unless (@move.destination.rank.to_i - @move.origin.rank.to_i).abs == 2
    return false if check_for_enemy_pawn_neighbors.empty?

    true
  end

  # return the square behind the pawn that moved
  def calculate_occupiable_en_passant_square
    case @move.piece.color
    when :black
      @move.destination.relative_position(up: 1)
    when :white
      @move.destination.relative_position(down: 1)
    end
  end

  # Check neighbors of destination square for an enemy pawn - purely for en passant
  def check_for_enemy_pawn_neighbors
    left = @move.destination.relative_position(left: 1)
    right = @move.destination.relative_position(right: 1)

    left_neighbor = if @move.board.on_board?(left) && !@move.board.get_piece(left).nil?
                      @move.board.get_piece(left)
                    else
                      false
                    end

    right_neighbor = if @move.board.on_board?(right) && !@move.board.get_piece(right).nil?
                       @move.board.get_piece(right)
                     else
                       false
                     end

    results = []
    results << left_neighbor if left_neighbor && left_neighbor.pawn? && left_neighbor.color != @move.piece.color

    results << right_neighbor if right_neighbor && right_neighbor.pawn? && right_neighbor.color != @move.piece.color

    results
  end
end
