require 'io/console'
require_relative 'checkers_errors'

class HumanPlayer
  attr_reader :color
  INSTRUCTION_STRING = "   a:\u21e6  w:\u21e7  d:\u21e8  s:\u21e9 \n" +
                        " k: add move l: submit"

  def initialize(color = :blue)
    @color = color
  end

  def handle_display(board, message)
    system('clear')
    puts "It's #{@color}'s turn."
    board.display
    puts INSTRUCTION_STRING
    puts message if message != ""
    message = ""
  end

  def get_move(board)
    board.cursor_display = nil
    board.cursor ||= [7,0]
    moves, message, move_completed = [], "", false
    until move_completed
      begin
        handle_display(board, message)
        input = $stdin.getch.downcase
        raise InvalidEntryError.new unless input =~ /[asdwxkl]/
        case input
        when 'a'
          board.cursor[1] -= 1 unless board.cursor[1] == 0
        when 's'
          board.cursor[0] += 1 unless board.cursor[0] == 7
        when 'd'
          board.cursor[1] += 1 unless board.cursor[1] == 7
        when 'w'
          board.cursor[0] -= 1 unless board.cursor[0] == 0
        when 'k'
          raise_errors_on_bad_k_input(board, moves)
          board.cursor_display ||= board[board.cursor].render 
          moves << board.cursor.dup
          board[board.cursor] = Placeholder.new
          move_completed = true if board.empty?(board.cursor)
        when 'l'
          if moves.size >= 2
            move_completed = true
          else
            raise InvalidSelectionError.new "Valid move sequence not entered."
          end
        when 'x'
          exit
        end
      rescue InvalidEntryError
        board.cursor_display = nil
        retry
      rescue InvalidSelectionError => e
        moves = []
        message = e.message
        board.cursor_display = nil
        retry
      end
    end

    moves
  end

  def raise_errors_on_bad_k_input(board, moves)
    if moves.empty?
      if board.empty?(board.cursor)
        raise InvalidSelectionError.new "Can't start with empty square!"
      elsif board[board.cursor].color != @color
        raise InvalidSelectionError.new "Please select your own piece."
      end
    end
  end

end