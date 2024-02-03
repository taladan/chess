# frozen_string_literal: true

# Square object
# - can hold a piece object 
# - has a color attribute 
# - can tell if it is occupied
class Square
  attr_reader :color
  attr_accessor :piece

  def initialize(color, piece=nil)
    @color = color
    @piece = piece
  end

  def occupied?
    !@piece.nil?
  end
end
