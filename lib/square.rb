class Square
  attr_reader :color, :piece
  
  def initialize(color, piece=nil)
    @color = color
    @piece = piece
  end
  
  def occupied?
    !@piece.nil?
  end
end