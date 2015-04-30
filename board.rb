class Board
  def initialize(start = true)
    @grid = generate_grid
    place_pieces if start
  end

  def display
    print "    0  1  2  3  4  5  6  7\n"
    @grid.each_with_index do |row, index|
      print " #{index} "
      row.each do |piece|
        print piece.nil? ? " * " : piece.render
      end
      print "\n"
    end

    nil
  end

  def empty?(pos)
    self[pos].nil?
  end

  def in_bounds?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
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
      self[[0, col]] = Piece.new([0, col], :black, self)
      self[[2, col]] = Piece.new([2, col], :black, self)
      self[[6, col]] = Piece.new([6, col], :white, self)
    end
    1.step(7, 2) do |col|
      self[[1, col]] = Piece.new([1, col], :black, self)
      self[[5, col]] = Piece.new([5, col], :white, self)
      self[[7, col]] = Piece.new([7, col], :white, self)
    end

    nil
  end
end