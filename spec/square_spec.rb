require './lib/square'

describe Square do
  square = Square.new(:white)
  describe "#occupied?" do
    it "returns false when unoccupied" do
      expect(square.occupied?).to be(false)
    end
    
    it "returns true when negated" do
      expect(!square.occupied?).to be(true)
    end
  end
end