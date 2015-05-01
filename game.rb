require_relative 'board'
require_relative 'piece'
require_relative 'human_player'
require_relative 'computer_player'

class CheckersGame
  def initialize(player1, player2)
    @player1, @player2 = player1, player2
    @board = Board.new
    @current_player = @player1
  end

  def play
    until over?
      take_turn
      switch_turn
    end
    @board.display
  end

  private

  def over?
    if @board.pieces.none?{ |piece| piece.color == :blue }
      system('clear')
      puts "Red wins!"
      return true
    elsif @board.pieces.none? { |piece| piece.color == :red }
      system('clear')
      puts "Blue wins!"
      return true
    end
    false
  end

  def parse_move(move_seq)
    selected_piece = @board[move_seq.shift]
    if selected_piece.color != @current_player.color
      raise InvalidMoveError.new "Please choose your own piece."
    end
    [selected_piece, move_seq]
  end

  def take_turn
    begin
      move_seq = @current_player.get_move(@board.dup)
      selected_piece, move_seq = parse_move(move_seq)
      selected_piece.perform_moves(move_seq)
    rescue InvalidMoveError => e
      puts e.message
      retry
    end
  end

  def switch_turn
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

end

if __FILE__ == $PROGRAM_NAME
  CheckersGame.new(HumanPlayer.new, ComputerPlayer.new).play
end