# frozen_string_literal: true

# Square object
# - can hold a piece object
# - has a color attribute
# - can tell if it is occupied
class Square
  attr_reader :color
  attr_accessor :piece, :rank, :file, :position

  def initialize(color, piece = nil)
    @color = color
    @piece = piece
    @position = nil
    @rank = nil
    @file = nil
  end

  def occupied?
    !@piece.nil?
  end
end
