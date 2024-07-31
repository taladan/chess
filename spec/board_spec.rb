# frozen_string_literal: true

require 'board'

describe Board do
  describe '#get' do
    it 'returns a square object from a string' do
      square = Board.new.get('A1')
      expect(square).to be_a(Square)
    end

    it 'returns a square object from a symbol' do
      square = Board.new.get(:g4)
      expect(square).to be_a(Square)
    end
  end

  describe '#get_piece' do
    it 'returns a piece object when passed a square that has a piece in it' do
      piece = Board.new.get_piece(:a1)
      expect(piece).to be_a(Piece)
    end

    it 'returns nil when asked to retrieve a piece from a square that is empty' do
      piece = Board.new.get_piece(:a5)
      expect(piece).to be(nil)
    end
  end

  describe '#on_board?' do
    it 'returns true when a position known to be on the board is given' do
      board = Board.new
      pos = :a1
      expect(board.on_board?(pos)).to be(true)
    end
  end

  describe '#on_board?' do
    it 'returns false when a position known to be off the board is given' do
      board = Board.new
      pos = :a12
      expect(board.on_board?(pos)).to be(false)
    end
  end

  describe '#path_clear?' do
    it 'returns true when path between the origin square and destination square is empty' do
      require_relative '../lib/move'
      board = Board.new
      piece = board.get_piece(:c2)
      destination = board.get(:c4).position
      move_object = Move.new(board, piece, destination)
      expect(board.path_clear?(move_object)).to be(true)
    end
  end

  describe '#path_clear?' do
    it 'returns false when path between the origin square and destination square is not empty' do
      require_relative '../lib/move'
      board = Board.new
      piece = board.get_piece(:c1)
      destination = board.get(:f4).position
      move_object = Move.new(board, piece, destination)
      expect(board.path_clear?(move_object)).to be(false)
    end
  end

  describe '#put' do
    it 'puts a new piece on the board when passed a symbol' do
      board = Board.new
      board.put(:queen, :e5, :black)
      expect(board.get(:e5).piece).to be_a(Queen)
    end
  end

  describe '#put' do
    it 'puts an existing piece on the board' do
      board = Board.new
      piece = board.get(:e2).piece
      board.put(piece, :c5)
      moved_piece = board.get(:c5).piece
      expect(moved_piece).to be(piece)
    end
  end

  describe '#remove_piece_from!!' do
    it 'returns a piece object' do
      board = Board.new
      piece = board.remove_piece_from!(:c2)
      expect(piece).to be_a(Pawn)
    end
  end

  describe '#remove_piece_from!' do
    it 'removes a piece from a square' do
      board = Board.new
      piece = board.remove_piece_from!(:g2)
      square = board.get(:g2)
      expect(square.piece).to be(nil)
    end
  end

  describe '#move_piece' do
    it 'tries to make a legal move with a pawn' do
      board = Board.new
      expect(board.move_piece(:h2, :h3)).to be(true)
    end
  end

  describe '#move_piece' do
    it 'tries perform an invalid move with a rook' do
      board = Board.new
      expect(board.move_piece(:h1, :h5)).to be(false)
    end
  end

  describe '#move_piece' do
    it 'tries to perform an invalid (diagonal) move with a pawn' do
      board = Board.new
      expect(board.move_piece(:h2, :g3)).to be(false)
    end
  end

  describe '#move_piece' do
    it 'tries to perform an invalid move with a pawn (too many spaces)' do
      board = Board.new
      expect(board.move_piece(:h2, :h5)).to be(false)
    end
  end

  describe '#move_piece' do
    it 'tries to move a king into a space checked by a queen' do
      board = Board.new
      board.remove_piece_from!(:d8)
      board.remove_piece_from!(:e2)
      board.remove_piece_from!(:e1)
      board.put(:king, :e2, :white)
      board.put(:queen, :d3, :black)
      expect(board.move_piece(:e2, :e3)).to be(false)
    end
  end

  describe '#move_piece' do
    it 'tries to move a king into a space checked by a pawn' do
      board = Board.new
      board.remove_piece_from!(:d7)
      board.remove_piece_from!(:e2)
      board.remove_piece_from!(:e1)
      board.put(:king, :e2, :white)
      board.put(:pawn, :d4, :black)
      expect(board.move_piece(:e2, :e3)).to be(false)
    end
  end

  describe '#move_piece' do
    it 'tries to make a valid move with a king' do
      board = Board.new
      board.remove_piece_from!(:d8)
      board.remove_piece_from!(:e2)
      board.remove_piece_from!(:e1)
      board.put(:king, :e2, :white)
      expect(board.move_piece(:e2, :e3)).to be(true)
    end
  end

  describe '#move_piece' do
    it 'tries to make an invalid move with a knight' do
      board = Board.new
      expect(board.move_piece(:b8, :c5)).to be(false)
    end
  end

  describe '#move_piece' do
    it 'tries to make a valid move with a knight' do
      board = Board.new
      orig_piece = board.get_piece(:b8)
      board.move_piece(:b8, :c6)
      expect(board.get_piece(:c6)).to eq(orig_piece)
    end
  end

  describe '#move_piece' do
    it 'tries to make a valid attack with a knight' do
      board = Board.new
      orig_piece = board.get_piece(:b8)
      board.put(:pawn, :c6, :white)
      board.move_piece(:b8, :c6)
      expect(board.get_piece(:c6)).to eq(orig_piece)
    end
  end

  describe '#move_piece' do
    it 'tries to make a valid attack with a pawn' do
      board = Board.new
      orig_piece = board.get_piece(:b7)
      board.put(:pawn, :c6, :white)
      board.move_piece(:b7, :c6)
      expect(board.get_piece(:c6)).to eq(orig_piece)
    end
  end

  describe '#move_piece' do
    it 'tries to perform an invalid move with a pawn (2 spaces on 2nd move)' do
      board = Board.new
      board.move_piece(:h2, :h3)
      expect(board.move_piece(:h3, :h5)).to be(false)
    end
  end

  describe '#move_piece' do
    it 'tries to perform a valid move with a rook' do
      board = Board.new
      board.remove_piece_from!(:a2)
      expect(board.move_piece(:a1, :a6)).to be(true)
    end
  end

  describe '#move_piece' do
    it 'tries to perform a valid attack with a rook' do
      board = Board.new
      board.remove_piece_from!(:a2)
      expect(board.move_piece(:a1, :a7)).to be(true)
    end
  end

  describe '#move_piece' do
    it 'tries to perform a valid move with a bishop' do
      board = Board.new
      board.remove_piece_from!(:d2)
      expect(board.move_piece(:c1, :h6)).to be(true)
    end
  end

  describe '#move_piece' do
    it 'tries to perform an invalid move with a bishop' do
      board = Board.new
      board.remove_piece_from!(:d2)
      expect(board.move_piece(:c1, :c6)).to be(false)
    end
  end

  describe '#move_piece' do
    it 'tries to perform a valid attack with a bishop' do
      board = Board.new
      board.remove_piece_from!(:d2)
      board.put(:rook, :f4, :black)
      expect(board.move_piece(:c1, :f4)).to be(true)
    end
  end

  describe '#move_piece' do
    it 'tries to perform an invalid move with a queen (invalid square)' do
      board = Board.new
      board.remove_piece_from!(:d2)
      expect(board.move_piece(:d1, :f4)).to be(false)
    end
  end

  describe '#move_piece' do
    it 'tries to perform a valid move with a queen' do
      board = Board.new
      board.remove_piece_from!(:d2)
      expect(board.move_piece(:d1, :d6)).to be(true)
    end
  end

  describe '#move_piece' do
    it 'tries to perform a valid move with a queen' do
      board = Board.new
      board.remove_piece_from!(:d2)
      expect(board.move_piece(:d1, :d7)).to be(true)
    end
  end

  describe '#move_piece' do
    it 'tries to perform an invalid move with a king' do
      board = Board.new
      board.remove_piece_from!(:e2)
      expect(board.move_piece(:e1, :e4)).to be(false)
    end
  end

  describe '#move_piece' do
    it 'tries to move a king into a square threatened by a rook' do
      board = Board.new
      board.remove_piece_from!(:e2)
      board.put(:rook, :a3, :black)
      expect(board.move_piece(:e1, :e2)).to be(true)
      expect(board.move_piece(:e2, :e3)).to be(false)
    end
  end

  describe '#move_piece' do
    it 'tries to move a king into a square threatened by a knight' do
      board = Board.new
      board.remove_piece_from!(:e2)
      board.put(:knight, :f4, :black)
      expect(board.move_piece(:e1, :e2)).to be(false)
    end
  end

  describe '#move_piece' do
    it 'tries to move a king into a square threatened by a bishop' do
      board = Board.new
      board.remove_piece_from!(:e2)
      board.put(:bishop, :b5, :black)
      expect(board.move_piece(:e1, :e2)).to be(false)
    end
  end

  describe '#move_piece' do
    it 'tries to move a king into a square threatened by a king' do
      board = Board.new
      board.remove_piece_from!(:e2)
      board.remove_piece_from!(:d2)
      board.remove_piece_from!(:d1)
      board.put(:king, :d3, :black)
      expect(board.move_piece(:e1, :e2)).to be(false)
    end
  end

  describe '#move_piece' do
    it 'tries to move a pawn and cause an en_passant condition' do
      board = Board.new
      board.put(:pawn, :b5, :white)
      board.move_piece(:a7, :a5)
      expect(board.en_passant).to be(true)
      expect(board.en_passant_square.to_sym).to be(:a5)
      expect(board.en_passant_square_opponent_will_occupy.to_sym).to be(:a6)
    end
  end

  describe '#move_piece' do
    it 'tries to move a pawn and does note cause an en_passant condition' do
      board = Board.new
      board.move_piece(:a2, :a4)
      expect(board.en_passant).to be(nil)
    end
  end

  describe 'move_piece' do
    it 'tries to make a valid castle of a king to the right' do
      board = Board.new
      %i[f1 g1].each do |square|
        board.remove_piece_from!(square)
      end
      expect(board.move_piece(:e1, :g1)).to be(true)
      expect(board.get_piece(:f1)).to be_a(Rook)
      expect(board.get_piece(:f1).has_moved?).to be(true)
      expect(board.get_piece(:g1)).to be_a(King)
      expect(board.get_piece(:g1).has_moved?).to be(true)
    end
  end

  describe 'move_piece' do
    it 'tries to make a valid castle of a king to the left' do
      board = Board.new
      %i[b1 c1 d1].each do |square|
        board.remove_piece_from!(square)
      end
      expect(board.move_piece(:e1, :c1)).to be(true)
      expect(board.get_piece(:d1)).to be_a(Rook)
      expect(board.get_piece(:d1).has_moved?).to be(true)
      expect(board.get_piece(:c1)).to be_a(King)
      expect(board.get_piece(:c1).has_moved?).to be(true)
    end
  end
end
