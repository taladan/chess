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
          square.rank = rank_index
          square.file = file_index
        end
      end
    end
  end

  def occupied?
    !@piece.nil?
  end
end
