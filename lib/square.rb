Class Square
  attr_reader: position, current_piece
  
  def initialize(color, current_piece=nil)
    @position = position
    @current_piece = current_piece
  end

end