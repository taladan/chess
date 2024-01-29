require './lib/board'

describe Board do
  describe "#get" do
    it "returns a square object" do
      square = Board.new.get("A1")
      expect(square).to be_a(Square)
    end
  end
end