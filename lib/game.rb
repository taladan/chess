# frozen_string_literal: true

require './lib/board'
require './lib/display'
require './lib/player'

# Game holds the data for an ongoing game of Chess
class Game
  attr_accessor :board
  attr_reader :display, :move_list, :player1, :player2, :save_dir

  def initialize
    @board = nil
    @display = Display.new
    @player1 = nil
    @player2 = nil
    @move_list = []
    @save_dir = './saves'
  end

  # prompt and set player data
  def init_players
    display.write('Enter the name of Player 1')
    name = gets.chomp
    new_player(name)
    display.write('Enter the name of Player 2')
    name = gets.chomp
    new_player(name)
  end

  # instantiate new board object
  def new_board
    @board = Board.new
  end

  # add move to list
  def update_movelist(move)
    @move_list << move
  end

  private

  # this may or may not live on.
  # todo: decide if this lives or not
  def new_player(name)
    if @player1.nil?
      @player1 = Player.new(name, :white)
    elsif @player2.nil?
      @player2 = Player.new(name, :black)
    else
      raise 'Players already set.'
    end
  end
end
