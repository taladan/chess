require_relative 'square'

# responsibilities include:
# - Initializing square objects into an accessible data 
#   structures for game board
# - Square handling
class Board
  def initialize
    # array of square objects representing the chess board
    @squares_array = initialize_squares
  end

  # Return a square object at a given location
  def get(square_name)
    rank_letter, file_number = square_name.to_s.downcase.chars
    rank_index = ("a".."h").to_a.reverse.index(rank_letter)
    file_index = file_number.to_i - 1
    @squares_array[rank_index][file_index]
  end

  private

  # populate array with square objects
  # for a chess board, the top left square from the white position (h1)
  # is always white.  Chess boards alternate white/black/white/black.
  #  The following rules apply:
  #  - If the row index is even and the cell index is odd, that will always be
  #    a white  square.
  #  - If a row index is even and a cell index is even, that will always
  #    be a black square
  #  - If a row index is odd and a cell index is even, that will always be a
  #    black square
  #  - if a row index is odd and a cell index is odd, that will always be a
  #    white square
  def initialize_squares
    array = Array.new(8) {Array.new(8)}
    array.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        if row_index.even?
          if cell_index.even?
            array[row_index][cell_index] = Square.new(:white)
          else
            array[row_index][cell_index] = Square.new(:black)
          end
        else
          if cell_index.odd?
            array[row_index][cell_index] = Square.new(:white)
          else
            array[row_index][cell_index] = Square.new(:black)
          end
        end
      end
    end
  end
end