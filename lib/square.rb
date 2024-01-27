class Square
  attr_reader :color, :current_piece
  
  def initialize(color, current_piece=nil)
    @color = color
    @current_piece = current_piece
  end
  
  def occupied?
    @current_piece != nil
  end
end