# frozen_string_literal: true

require "position"

describe Position do
  describe "#xy" do
    it "returns a positional array in x/y order" do
      position = Position.new(:b3)
      expect(position.xy).to eq([2,1])
    end
  end
    
  describe "#yx" do
    it "returns a positional array in y/x order" do
      position = Position.new(:b3)
      expect(position.yx).to eq([1,2])
    end
  end
  
  describe "#relative_position" do
    it "returns a symbol that consists of a single character and a single number" do
      position = Position.new(:a1)
      target = position.relative_postion(name: :a1, up:1)
      expect(target).to be_a(Symbol)
      file, rank = target.to_s.split('', 2)
      expect(file).to be_a(String)
      expect(file.length).to be(1)
      expect(rank.to_i).to be_a(Integer)
      expect(rank.length).to be(1)
    end
  end
end