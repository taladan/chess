# frozen_string_literal: true

# Controls the building of the chess display
class Display
  def initialize
    @board = nil
  end

  # pass game board into display
  def initialize_board(board)
    @board = board
  end

  # redraw the screen
  def refresh
    system('clear') || systemr('cls')
    puts header
    puts board_string
    puts "\n\n"
  end

  # write to screen
  def write(msg, norefresh: false)
    clear_and_header unless norefresh
    if msg.is_a?(Array)
      array_write(msg)
    else
      puts msg
    end
  end

  private

  def clear_and_header
    system('clear') || system('cls')
    puts header
    puts "\n\n"
  end

  # write an array to screen, newline with numbers
  def array_write(msg_array)
    msg_array.each_with_index do |element, index|
      puts "\t#{index + 1}. #{element}\n"
    end
  end

  # return a string representation of the complete board with labels
  def board_string
    array = []
    array << "\n\t\t\t"
    @board.ranks.keys.reverse_each do |rank|
      array << rank_string_formatter(rank, @board.ranks[rank])
    end
    array << @board.file_labels
    array.join
  end

  # Ascii header for game
  def header
    "     ██████╗ ██████╗ ██╗███╗   ██╗     ██████╗██╗  ██╗███████╗███████╗███████╗
    ██╔═══██╗██╔══██╗██║████╗  ██║    ██╔════╝██║  ██║██╔════╝██╔════╝██╔════╝
    ██║   ██║██║  ██║██║██╔██╗ ██║    ██║     ███████║█████╗  ███████╗███████╗
    ██║   ██║██║  ██║██║██║╚██╗██║    ██║     ██╔══██║██╔══╝  ╚════██║╚════██║
    ╚██████╔╝██████╔╝██║██║ ╚████║    ╚██████╗██║  ██║███████╗███████║███████║
    ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝     ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝\n"
  end

  # This gathers the various strings of the board and returns them as an array
  def rank_string_formatter(label_key, rank)
    output_array = []
    output_array << get_top_row(rank)
    output_array << @board.rank_labels[label_key]
    output_array << get_middle_row(rank)
    output_array << get_bottom_row(rank)
  end

  # return an array of strings that represent the top row of the rank display with a linebreak appended
  def get_top_row(rank)
    output_array = []
    rank.each do |square|
      output_array << @board.get(square).show[:top]
    end
    output_array << "\n\t\t      "
  end

  # return an array of strings that represent the middle row of the rank display with a linebreak appended
  def get_middle_row(rank)
    output_array = []
    rank.each do |square|
      output_array << @board.get(square).show[:middle]
    end
    output_array << "\n\t\t\t"
  end

  # return an array of strings that represent the bottom row of the rank display with a linebreak appended
  def get_bottom_row(rank)
    output_array = []
    rank.each do |square|
      output_array << @board.get(square).show[:bottom]
    end
    output_array << "\n\t\t\t"
  end
end
