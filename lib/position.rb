# frozen_string_literal: true

# Position is responsible for dealing with coordinates
class Position
  attr_reader :x, :y, :rank, :file

  def initialize(square_name)
    @file, @rank = square_name.to_s.downcase.split('', 2)
    @x = (1..8).to_a.index(@rank.to_i)
    @y = ('a'..'h').to_a.index(@file)
  end

  # string
  def to_s
    to_sym.to_s
  end
  # equivalent positions
  def ==(other)
    self.class == other.class &&
      @x == other.x &&
      @y == other.y &&
      to_sym == other.to_sym
  end

  # xy
  def xy
    [x, y]
  end

  # yx
  def yx
    [y, x]
  end

  def to_sym
    (@file + @rank.to_s).to_sym
  end

  # calculate relative position
  # expects:
  # - One or more of:
  #   - :up
  #   - :down
  #   - :left
  #   - :right
  def relative_position(**direction)
    #starting values
    @target_rank = @rank
    @target_file = @file

    # iterate all directions and perform calculation
    direction.each do |key, amount|
      case key
      when :up
        @target_rank = @rank.to_i + amount.to_i
      when :down
        @target_rank = @rank.to_i - amount.to_i
      when :left
        @target_file = (@file.ord - amount.to_i).chr
      when :right
        @target_file = (@file.ord + amount.to_i).chr
      end
    end

    # return a new position object of the calculated position
    Position.new((@target_file + @target_rank.to_s).to_sym)
  end
end
