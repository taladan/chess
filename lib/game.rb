# frozen_string_literal: true

require './lib/board'
require './lib/display'
require './lib/player'

# Game holds the data for an ongoing game of Chess
class Game
  attr_accessor :board
  attr_reader :display, :move_list, :white, :black, :save_dir, :started, :turn

  def initialize
    @board = nil
    @started = false
    @display = Display.new
    @white = nil
    @black = nil
    @move_list = []
  end

  # prompt and set player data
  def init_players
    display.write('Enter the name of Player 1')
    name = gets.chomp
    @white = new_player(name)
    display.write('Enter the name of Player 2')
    name = gets.chomp
    @black = new_player(name)
    @turn = @white
  end

  def start
    @started = true
  end

  # instantiate new board object
  def new_board
    @board = Board.new
  end

  # add move to list
  def update_movelist(move)
    @move_list << move
  end

  def move_piece
    # move logic here
  end

  private

  # this may or may not live on.
  # todo: decide if this lives or not
  def new_player(name)
    if @white.nil?
      @white = Player.new(name, :white)
    elsif @black.nil?
      @black = Player.new(name, :black)
    else
      raise 'Players already set.'
    end
  end
end
