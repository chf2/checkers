require 'colorize'

class Board
  attr_accessor :cursor, :cursor_display
  def initialize(start = true)
    @grid = generate_grid
    place_pieces if start
    @cursor, @cursor_display = nil, nil
  end

  def display
    @grid.each_with_index do |line, row|
      line.each_with_index do |piece, col|
        display = " #{piece.nil? ? ' ' : piece.render} "
        background = (row + col).even? ? :black : :white
        if @cursor == [row, col]
          background = :light_cyan
          display = (@cursor_display ? " #{@cursor_display} " : "   ")
        end
        print display.colorize(:background => background)
      end
      print "\n"
    end

    nil
  end

  def dup
    new_board = Board.new(false)
    self.pieces.each do |piece|
      new_board[piece.pos]= Piece.new(piece.pos.dup, 
                                      piece.color, 
                                      new_board, 
                                      piece.king)
    end

    new_board
  end

  def empty?(pos)
    self[pos].nil?
  end

  def in_bounds?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def pieces
    @grid.flatten.reject { |position| position.nil? }
  end

  def [](pos)
    y, x = pos
    @grid[y][x]
  end

  def []=(pos, piece)
    y, x = pos
    @grid[y][x] = piece
  end

  private

  def generate_grid
    Array.new(8) { Array.new(8) }
  end

  def place_pieces
    0.step(6, 2) do |col|
      self[[0, col]] = Piece.new([0, col], :red, self)
      self[[2, col]] = Piece.new([2, col], :red, self)
      self[[6, col]] = Piece.new([6, col], :blue, self)
    end
    1.step(7, 2) do |col|
      self[[1, col]] = Piece.new([1, col], :red, self)
      self[[5, col]] = Piece.new([5, col], :blue, self)
      self[[7, col]] = Piece.new([7, col], :blue, self)
    end

    nil
  end
end