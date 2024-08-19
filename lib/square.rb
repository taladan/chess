# frozen_string_literal: true

require 'colorize'

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

  # Build square display
  def show
    pad = '    '
    mid = occupied? ? " #{piece.icon}  " : pad
    pad = color == :white ? pad.on_white : pad.on_light_black
    mid = color == :white ? mid.on_white : mid.on_light_black
    { top: pad, middle: mid, bottom: pad }
  end

  # populate array with square objects
  def self.initialize_squares
    #  The following rules apply:
    #  - rank index even && file index even - black square.
    #  - rank index even && file index odd - white  square.
    #  - rank index odd && file index even - black square.
    #  - rank index odd && file index odd - white  square.

    Array.new(8) do |y_index|
      Array.new(8) do |x_index|
        color = (y_index + x_index).even? ? :white : :black
        Square.new(color).tap do |square|
          square.y = y_index
          square.x = x_index
        end
      end
    end
  end

  # return boolean true if square has a piece in it's current position
  def occupied?
    !@piece.nil?
  end

  # return array of y/x coords
  # note: y/x is used in ncurses instead of x/y
  def yx
    [@y, @x]
  end
end
