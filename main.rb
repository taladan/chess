# frozen_string_literal: true

require './lib/game'

###########
# Most of the stuff besides the mainloop is
# likely going to be pulled out of here and
# parted up into other objects/logic
###########

# instantiate game object
$game = Game.new

# Game loop
def mainloop
  $game.display.write("Welcome to Odin Chess\n\n")
  start_menu
  board = $game.board
  $game.display.initialize_board(board)
  keep_running = true

  # Main loop
  while keep_running
    $game.display.refresh
    parse_input(ingame_menu)
  end
end

# menu of choices to initialize game
def start_menu
  input = ''
  puts('(N)ew Game, (L)oad Game, or (Q)uit?')
  input = gets.chomp.upcase until %w[N L Q].include?(input)
  case input
  when 'N'
    new_game
  when 'L'
    load_game
  when 'Q'
    exit!
  end
end

# menu for gameplay
def ingame_menu
  options = '(M)ove a piece, (S)ave this game, (Q)uit'
  $game.display.write(options, norefresh: true)
  input = gets.chomp.upcase until %w[M S Q].include?(input)
  input
end

# Allow player to choose from saved games
def choose_save(saves)
  prompt = "Please enter a number 1-#{saves.length}"
  $game.display.write(prompt, norefresh: true)
  input = gets.chomp.upcase until (1..saves.length + 1).to_a.include?(input)
  input
end

# execute menu choices
def parse_input(choice)
  move_piece if choice == 'M'
  exit! if choice == 'Q'
  save_game if choice == 'S'
end

# list and loads game files
# TODO: Nail logic down
def load_game
  filenames, saves = list_game_saves
  $game.display.write(filenames)
  load_save(filenames[choose_save(saves) - 1])
end

# set up a new game
# TODO: Nail logic down
def new_game
  $game.new_board
  $game.init_players
end

# save the current board state
# TODO: Nail logic down
def save_game
  msg = 'FOOP!!'
  $game.display.write(msg, norefresh: true)
  # marshal the data
  # name the file
  # write the file to the directory
end

# return array of filenames and an array of paths in the $game_save directory
def list_game_saves
  filenames = []
  paths = []
  Dir.glob("#{$game.save_dir}/*.chess").each do |file|
    paths << file
    filenames << File.basename(file, '.*')
  end
  [filenames, paths]
end

# load the actual save
# TODO: Nail logic down
def load_save(path)
  $game = Marshal.load(File.read(path))
end

mainloop if __FILE__ == $0
