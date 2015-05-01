require_relative 'checkers_errors'
require 'colorize.rb'

class Piece
  attr_accessor :pos 
  attr_reader :color, :king
  MOVE_DIRS_BLUE = [[-1, -1], [-1, 1]]
  MOVE_DIRS_RED = [[1, -1], [1, 1]]

  def initialize(pos, color, board, king = false)
    @pos, @color, @board, @king = pos, color, board, king
  end

  def check_for_captures(board, friendly_pieces)
    friendly_pieces.any? do |piece|
      piece.moves.any? do |move|
        if board[move] && board[move].is_opponent?(piece.color)
          piece.valid_move_seq?([move])
        end
      end
    end
  end

  def check_for_promotion
    back_row = blue? ? 0 : 7
    @king = true if @pos[0] == back_row
  end

  def inspect
    @pos.inspect
  end

  def is_opponent?(color)
    @color != color
  end

  def moves
    if @king
      deltas = MOVE_DIRS_BLUE + MOVE_DIRS_RED
    else
      deltas = blue? ? MOVE_DIRS_BLUE : MOVE_DIRS_RED
    end

    deltas
      .map { |dy, dx| [dy + @pos[0], dx + @pos[1]]}
      .select { |pos| @board.in_bounds?(pos) }
  end

  def perform_moves(move_seq)
    if valid_move_seq?(move_seq)
      perform_moves!(move_seq)
    else
      raise InvalidMoveError.new "Not a valid move sequence."
    end
  end

  def perform_moves!(move_seq, board = @board)
    if move_seq.size == 1
      board.display
      moved = perform_slide(move_seq[0], board) || perform_jump(move_seq[0], board)
      raise InvalidMoveError.new unless moved
    else
      move_seq.each do |move|
        moved = perform_jump(move)
        raise InvalidMoveError.new unless moved
      end
    end

    true
  end

  def perform_slide(move_to, board = @board)
    return false unless board.empty?(move_to) && moves.include?(move_to)
    friendly_pieces = board.pieces.select { |piece| piece.color == @color}
    must_capture = check_for_captures(board, friendly_pieces)
    return false if must_capture
    
    board[move_to], board[@pos] = self, nil
    @pos = move_to
    check_for_promotion
    true
  end

  def perform_jump(move_over, board = @board)
    piece_to_jump = board[move_over]
    return false unless piece_to_jump && piece_to_jump.color != @color
    return false unless moves.include?(move_over)
    
    new_pos = [2 * move_over[0] - @pos[0], 2 * move_over[1] - @pos[1]]
    return false unless board.empty?(new_pos) && board.in_bounds?(new_pos)

    board[@pos], board[move_over], board[new_pos] = nil, nil, self
    @pos, piece_to_jump.pos = new_pos, nil
    check_for_promotion
    true
  end

  def render
    if @king
      blue? ? "♚".colorize(:blue) : "♚".colorize(:red)
    else
      blue? ? "\u25cf".colorize(:blue) : "\u25cf".colorize(:red)
    end
  end

  def valid_move_seq?(move_seq)
    dup_board = @board.dup
    dup_piece = dup_board[@pos]
    begin
      dup_piece.perform_moves!(move_seq, dup_board)
    rescue InvalidMoveError
      return false
    else
      return true
    end
  end

  def blue?
    @color == :blue
  end

end