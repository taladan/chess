# frozen_string_literal: true

require 'date'

# This object handles loading and saving of chess games
class Save
  attr_reader :directory

  def initialize(game)
    @game = game
    @directory = './saves'
  end

  # save the current board state
  # TODO: Nail logic down
  # TODO: need to put in a filename check for games
  def game
    # name the file
    filename = "#{@directory}/#{@game.white.name}_vs_#{@game.black.name}-#{Date.today}.chess"

    # Marhsal and write the file to the directory
    File.open(filename, 'wb') { |file| file.write(Marshal.dump(@game)) }
    @game.display.write("Game Saved as #{File.basename(filename)}", norefresh: true)
  end

  # return array of filenames and an array of paths in the save directory
  def list
    filenames = []
    paths = []
    Dir.glob("#{@directory}/*.chess").each do |file|
      paths << file
      filenames << File.basename(file, '.*')
    end
    [filenames, paths]
  end

  # list and loads game files
  def load
    # An array of prettified file names and an array of actual file paths
    filenames, saves = list
    @game.display.write(filenames)
    choice = choose_save(saves)
    @game = Marshal.load(File.read(saves[choice]))
    @game
  end

  # manage save files
  def manage
    @game.display.write('(D)elete or (R)ename save?')
    input = gets.chomp.upcase
    until %w[D R].include?(input)
      @game.display.write("Invalid choice, please enter 'D' for delete or 'R' for rename.")
      input = gets.chomp.upcase
    end

    case input
    when 'D'
      delete
    when 'R'
      rename
    end
  end

  private

  # step through deleting a save
  def delete
    filenames, saves = list
    @game.display.write(filenames)
    choice = choose_save(saves)
    @game.display.write("You have chosen to delete #{filenames[choice]}.  This cannot be undone, are you sure? (Y/N)",
                        norefresh: true)
    del = gets.chomp.upcase
    until %w[Y N].include?(del)
      @game.display.write("Invalid choice, please type 'Y' or 'N'", norefresh: true)
      @game.display.write(
        "You have chosen to delete #{filenames[choice]}.  This cannot be undone, are you sure? (Y/N)", norefresh: true
      )
      del = gets.chomp.upcase
    end
    if del == 'Y'
      File.delete(saves[choice]) if File.exist?(saves[choice])
    else
      @game.display.write('Aborting save management.')
      @game.board = nil
    end
  end

  # Rename a file
  def rename
    filenames, saves = list
    @game.display.write(filenames)
    choice = choose_save(saves)
    @game.display.write("Please enter a new name for the file #{filenames[choice]}", norefresh: true)
    ren = gets.chomp

    # exit method without renaming if no name given
    return @game.board = nil if ren == ''

    File.rename(saves[choice], @directory + '/' + ren.strip + File.extname(saves[choice]))
    @game.board = nil
  end

  # Allow player to choose from saved games returns an integer
  def choose_save(saves)
    prompt = "Please enter a number 1-#{saves.length}"
    @game.display.write(prompt, norefresh: true)
    input = 0
    input = gets.chomp.to_i until (1..saves.length).to_a.include?(input)
    input - 1
  end
end
