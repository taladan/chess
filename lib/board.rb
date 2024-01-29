require_relative 'square'

# responsibilities include:
# - Initializing square objects into an accessible data 
#   structures for game board
# - Square handling
class Board
  attr_reader :squares_array, :square_positions
  def initialize
    # array of square objects representing the chess board
    @squares_array = initialize_squares
    # hash of square names as keys and their board positions as values
    @square_positions = set_positions
  end

  # Return a square object at a given location
  def get(square)
    key = square.downcase.to_sym
    position = @square_positions[key]
    @squares_array[position.first][position.last]
  end

  private

  # return hash of values where a square's name (A1)
  # is a symbol acting as a hash key
  # and the value is the array position on the board of that square
  def set_positions
    position_keys = generate_keys

    # I need to make a hash of square names: [x,y] pos
    hsh = {}
    position_keys.each do |key|
      hsh[key] = calculate_position_from_square_name(key.to_s)
    end
    hsh
  end

  # return a 2 value array that translates from the string name
  # of a given square into the rank and file position of that esquaree
  def calculate_position_from_square_name(string)
    temp_array = []
    # determine and set the rank values of the chess square
    case string[0]
    when 'a'
      temp_array[0] = 7
    when 'b'
      temp_array[0] = 6
    when 'c'
      temp_array[0] = 5
    when 'd'
      temp_array[0] = 4
    when 'e'
      temp_array[0] = 3
    when 'f'
      temp_array[0] = 2
    when 'g'
      temp_array[0] = 1
    when 'h'
      temp_array[0] = 0
    end

    # determine and set the file of the chess square
    temp_array[1] = string[1].to_i - 1

    # return the value of the array
    temp_array
  end

  # return an array of symbols 'a1-h8'
  def generate_keys
    ('a'..'h').to_a.flat_map do |letter|
      (1..8).map do |num| 
        "#{letter}#{num}".to_sym
      end
    end
  end

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