class ComputerPlayer
  attr_reader :color
  def initialize(color = :red)
    @color = color
  end

  def get_move(board)
    moves = []
    pieces = board.pieces.select { |piece| piece.color == @color }.shuffle
    pieces.each do |piece|
      moves << piece.pos
      piece.moves.each do |move|
        moves << move
        return moves if piece.valid_move_seq?(moves.drop(1))
        moves.pop
      end
      moves = []
    end

    raise "NO VALID MOVES!"
  end
end