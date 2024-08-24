# frozen_string_literal: true

require './lib/game'
require './lib/save'

###########
# Most of the stuff besides the mainloop is
# likely going to be pulled out of here and
# parted up into other objects/logic
###########
class Chess
  def initialize
    @game = Game.new
    mainloop
  end

  # instantiate game object

  # Game loop
  def mainloop
    @game.display.write("Welcome to Odin Chess\n\n")
    @save = Save.new(@game)
    start_menu
    board = @game.board
    @game.display.initialize_board(board)
    @game.start

    # Pass Board to display
    keep_running = true

    # Main loop
    while keep_running
      @game.display.refresh
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
      @game.new_board
      @game.init_players
    when 'L'
      @game = @save.load
    when 'Q'
      exit!
    end
  end

  # menu for gameplay
  def ingame_menu
    options = '(M)ove a piece, (S)ave this game, (Q)uit'
    @game.display.write(options, norefresh: true)
    @game.display.write("#{@game.turn.name}'s move\n", norefresh: true)
    input = gets.chomp.upcase until %w[M S Q].include?(input)
    input
  end

  # execute menu choices
  def parse_input(choice)
    @game.move_piece if choice == 'M'
    exit! if choice == 'Q'
    @save.game if choice == 'S'
  end
end

Chess.new if __FILE__ == $0
