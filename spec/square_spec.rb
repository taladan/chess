require './lib/square'

describe Square do
  describe "#occupied?" do
    it "returns false when unoccupied" do
      square = Square.new(:white)
      expect(square.occupied?).to be(false)
    end
    
    it "returns true when occupied" do
      square = Square.new(:white, :piece)
      expect(square.occupied?).to be(true)
    end
  end
end