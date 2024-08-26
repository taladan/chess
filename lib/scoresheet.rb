# frozen_string_literal: true

# This class is currently unimplemented within the schema
# of chess.  It may or may not live on.
class Scoresheet
  def intialize
    @moves = { white: {}, black: {} }
  end

  def set_players(white, black)
    @white = white
    @black = black
  end
end
