# frozen_string_literal: true

require './lib/board'
require './lib/display'
require './lib/player'
require './lib/checkmate'
require './lib/scoresheet'

# Game holds the data for an ongoing game of Chess
class Game
  attr_accessor :board
  attr_reader :display, :move_list, :white, :black, :started, :turn

  def initialize
    @board = nil
    @started = false
    @display = Display.new
    @scoresheet = Scoresheet.new
    @white = nil
    @black = nil
  end

  # check for check
  def check?
    Checkmate.new(@board).check?
  end

  # check for mate
  def checkmate?
    Checkmate.new(@board).checkmate?
  end

  def checked_color
    Checkmate.new(@board).kings_in_check.pop.color
  end

  # prompt and set player data
  def init_players
    display.write('Enter the name of Player 1')
    name = gets.chomp
    @white = Player.new(name, :white)
    display.write('Enter the name of Player 2')
    name = gets.chomp
    @black = Player.new(name, :black)

    # initialize players on the scoresheet
    @scoresheet.set_players(@white, @black)

    # white always moves first
    @turn = @white
  end

  # update the status of the game for load/save purposes
  def start
    @started = true
  end

  # Menu option for moving a piece from a player's perspective
  def player_move
    return if en_passant_check

    @display.refresh

    if check?
      player = @white.color == checked_color ? @white.name : @black.name
      @display.write("\n#{player} is in check!", norefresh: true)
    end

    @display.write("Enter your move (it should follow the format: 'a2,a4'): ", norefresh: true)
    input = gets.chomp
    until verified?(input)
      @display.refresh
      @display.write("Incorrect format, please enter your move (it should follow the format: 'a2,a4'):",
                     norefresh: true)
      input = gets.chomp
    end

    # explicitly split the input into source and target symbols
    source, target = input.split(',').map(&:to_sym)

    # white should only be able to move white pieces
    piece = @board.get_piece(source)
    raise InvalidMove, 'You can not move a piece belonging to an opponent' if piece.color != @turn.color

    # some sort of validation is going to have to happen here
    @board.move_piece(source, target)
    swap_turn

    # update scoresheet
    # This may come later but is not required for the project spec.
  end

  # instantiate new board object
  def new_board
    @board = Board.new
  end

  private

  def swap_turn
    @turn = @turn == @white ? @black : @white
  end

  def en_passant_check
    return false if @board.en_passant == false

    input = ''
    until %w[Y N].include?(input)
      @display.refresh
      @display.write(
        "#{@turn.name}, you may capture a pawn en passant, would you like to <y/n>? (this will count as your move)", norefresh: true
      )
      input = gets.chomp.upcase
    end
    case input
    when 'N'
      @board.reset_enpassant
    when 'Y'
      if @board.en_passant.threat.length == 2
        choices = @board.en_passant.threat.map { |piece| piece.current_square.to_s }
        input = ''
        until choices.include?(input)
          @display.refresh
          @display.write("#{@turn.name}, which piece would you like to capture with #{choices[0]} or #{choices[1]}?",
                         norefresh: true)
          input = gets.chomp.downcase
        end
        _captured_piece = @board.remove_piece_from!(@board.en_passant.square)
        capturing_piece = @board.remove_piece_from!(input)
        @board.put(capturing_piece, @board.en_passant.opponent_target_square)
        @board.reset_enpassant
        swap_turn
      else
        _captured_piece = @board.remove_piece_from!(@board.en_passant.square)
        capturing_piece = @board.remove_piece_from!(@board.en_passant.threat[0].current_square.to_sym)
        @board.put(capturing_piece, @board.en_passant.opponent_target_square)
        @board.reset_enpassant
        swap_turn
      end
    end
  end

  # regex match input against the pattern a1 - ah for the source and target
  def verified?(input)
    !!(input =~ /^[a-hA-H][1-8],[a-hA-H][1-8]$/i)
  end
end
