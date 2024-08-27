# frozen_string_literal: true

require './lib/game'
require './lib/save'
require './lib/exceptions'
require 'fileutils'

# This object initializes a game of chess and contains the main game loop
class Chess
  def initialize
    @game = Game.new
    @game.display.write("Welcome to Odin Chess\n\n")
    @save = Save.new(@game)
    save_directory
    start_menu
    board = @game.board
    @game.display.initialize_board(board)
    @game.start
    mainloop
    # check for a saves directory and create it if it doesn't exist
  end

  # Game loop
  def mainloop
    # Pass Board to display
    keep_running = true

    # Main loop
    while keep_running
      keep_running = false if @game.checkmate?
      if @game.checkmate?
        end_game
      else
        @game.display.refresh
        parse_input(ingame_menu)
      end
    end
  end

  # menu of choices to initialize game
  def start_menu
    input = ''
    @game.display.write('(N)ew Game, (L)oad Game, or (Q)uit?', norefresh: true)
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

  private

  def save_directory
    FileUtils.mkdir_p @save.directory unless File.directory?(@save.directory)
  end

  # menu for gameplay
  def ingame_menu
    options = '(M)ove a piece, (S)ave this game, (Q)uit'
    @game.display.write(options, norefresh: true)
    @game.display.write("#{@game.turn.name}'s move\n", norefresh: true)
    input = gets.chomp.upcase
    until %w[M S Q].include?(input)
      @game.display.refresh
      @game.display.write('Invalid Choice.', norefresh: true)
      @game.display.write(options, norefresh: true)
      @game.display.write("#{@game.turn.name}'s move\n", norefresh: true)
      input = gets.chomp.upcase
    end
    input
  end

  # execute menu choices
  def parse_input(choice)
    begin
      @game.player_move if choice == 'M'
    rescue InvalidMove => e
      @game.display.write(e, norefresh: true)
      sleep(3)
      @game.display.refresh
    end
    exit! if choice == 'Q'
    save if choice == 'S'
  end

  def save
    @save.game
    sleep(1)
    @game.display.refresh
  end
end

# This terminates the game loop
def end_game
  winner = @game.white.color == @game.check_mated_color ? @game.black : @game.white
  @game.display.refresh
  @game.display.write("#{winner.name} wins!  Congratulations on a well fought victory!")
  sleep(3)
  exit!
end

Chess.new if __FILE__ == $0
