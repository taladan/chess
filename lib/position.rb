# frozen_string_literal: true

# Position is responsible for dealing with coordinates
class Position
  attr_reader :x, :y, :rank, :file

  def initialize(square_name)
    @file, @rank = square_name.to_s.downcase.split('', 2)
    @x = (1..8).to_a.index(@rank.to_i)
    @y = ('a'..'h').to_a.index(@file)
  end

  # equivalent positions
  def ==(other)
    self.class == other.class &&
      @x == other.x &&
      @y == other.y &&
      file_and_rank == other.file_and_rank
  end


  # xy
  def xy
    [x, y]
  end

  # yx
  def yx
    [y, x]
  end

  def file_and_rank
    (@file + @rank.to_s).to_sym
  end

  # calculate relative position
  # expects:
  # - :name
  # - One or more of:
  #   - :up
  #   - :down
  #   - :left
  #   - :right
  def relative_postion(**direction)
    direction.each_key do |key|
      case key
      # deal with name
      when :name
        :name # possibly do something later here
      # up: 2 = @rank + 2
      when :up
        @target_rank = @rank.to_i + direction[:up]
        @target_file = @file
      # down: 2 = @rank - 2
      when :down
        @target_rank = @rank.to_i - direction[:down]
        @target_file = @file
      # left: 2 = @file + 2 = (@file.ord + 2).chr
      when :left
        @target_file = (@file.ord - direction[:left]).chr
        @target_rank = @rank
      # right: 2 = @file - 2 = (@file.ord - 2).chr
      when :right
        @target_file = (@file.ord + direction[:right]).chr
        @target_rank = @rank
      end
    end
    Position.new((@target_file + @target_rank.to_s).to_sym)
  end
end
