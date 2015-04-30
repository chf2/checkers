class Piece
  attr_accessor :pos 
  attr_reader :color
  MOVE_DIRS_WHITE = [[-1, -1], [-1, 1]]
  MOVE_DIRS_BLACK = [[1, -1], [1, 1]]

  def initialize(pos, color, board, king = false)
    @pos, @color, @board, @king = pos, color, board, king
  end

  def check_for_promotion
    back_row = white? ? 0 : 7
    @king = true if @pos[0] == back_row
  end

  def inspect
    [render, @pos, @king].inspect
  end

  def moves
    if @king
      deltas = MOVE_DIRS_WHITE + MOVE_DIRS_BLACK
    else
      deltas = white? ? MOVE_DIRS_WHITE : MOVE_DIRS_BLACK
    end

    deltas
      .map { |dy, dx| [dy + @pos[0], dx + @pos[1]]}
      .select { |pos| @board.in_bounds?(pos) }
  end

  def perform_moves!(move_sequence)
    if move_sequence.size == 1


  end

  def perform_slide(move_to)
    return false unless @board.empty?(move_to) && moves.include?(move_to)
    @board[move_to], @board[@pos] = self, nil
    @pos = move_to
    check_for_promotion
    true
  end

  def perform_jump(move_over)
    piece_to_jump = @board[move_over]
    return false unless piece_to_jump && piece_to_jump.color != @color
    return false unless moves.include?(move_over)
    
    new_position = [2 * move_over[0] - @pos[0], 2 * move_over[1] - @pos[1]]
    return false unless @board.empty?(new_position)

    @board[@pos], @board[move_over], @board[new_position] = nil, nil, self
    @pos, piece_to_jump.pos = new_position, nil
    check_for_promotion
    true
  end

  def render
    display = white? ? " W " : " B "
    display.gsub!(' ', 'K') if @king
    display
  end

  def white?
    @color == :white
  end

end