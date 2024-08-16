# frozen_string_literal: true

# Square object
# - can hold a piece object
# - has a color attribute
# - can tell if it is occupied
class Square
  attr_reader :color
  attr_accessor :piece, :y, :x, :position

  def initialize(color, piece = nil)
    @color = color
    @piece = piece
    @position = nil
    @y = nil
    @x = nil
  end

  # populate array with square objects
  def self.initialize_squares
    #  The following rules apply:
    #  - rank index even && file index even - black square.
    #  - rank index even && file index odd - white  square.
    #  - rank index odd && file index even - black square.
    #  - rank index odd && file index odd - white  square.

    Array.new(8) do |rank_index|
      Array.new(8) do |file_index|
        color = (rank_index + file_index).even? ? :white : :black
        Square.new(color).tap do |square|
          square.y = rank_index
          square.x = file_index
        end
      end
    end
  end

  # return boolean true if square has a piece in it's current position
  def occupied?
    !@piece.nil?
  end
end
