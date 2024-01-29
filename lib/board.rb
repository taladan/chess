require_relative 'square'

# responsibilities include:
# - Initializing square objects into an accessible data 
#   structures for game board
# - Square handling
class Board
  def initialize
    # array of square objects representing the chess board
    @squares = initialize_squares
  end

  # Return a square object at a given location
  def get(square_name)
    rank_letter, file_number = square_name.to_s.downcase.chars
    rank_index = ("a".."h").to_a.reverse.index(rank_letter)
    file_index = file_number.to_i - 1
    @squares[rank_index][file_index]
  end

  private

  # populate array with square objects
  # for a chess board, the top left square from the white position (h1)
  # is always white.  Chess boards alternate white/black/white/black.
  #  The following rules apply:
  #  - rank index even && file index even - black square.
  #  - rank index even && file index odd - white  square.
  #  - rank index odd && file index even - black square.
  #  - rank index odd && file index odd - white  square.
  def initialize_squares
    array = Array.new(8) {Array.new(8)}
    array.each_with_index do |rank, rank_index|
      rank.each_index do |file_index|
        if rank_index.even? # Even rank index
          if file_index.even? # Even file index
            array[rank_index][file_index] = Square.new(:white)
          else # Odd file index
            array[rank_index][file_index] = Square.new(:black)
          end
        else # Odd rank index
          if file_index.odd? # Odd file index
            array[rank_index][file_index] = Square.new(:white)
          else # Even file index
            array[rank_index][file_index] = Square.new(:black)
          end
        end
      end
    end
  end
end