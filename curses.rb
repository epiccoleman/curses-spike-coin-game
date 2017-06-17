require 'curses'

class Board
  def initialize(side_length)
    @side_length = side_length
    middle = side_length / 2
    place_player(Point.new(middle, middle))
  end

  def clear_board
    @board = Array.new(@side_length) { Array.new(@side_length, '.') }
  end

  def place_player(point)
    clear_board
    @board[point.y][point.x] = '0'
    @player_pos = point
  end

  def validate_new_pos(new_pos)
    new_pos.x >= 0 \
      and new_pos.y >= 0 \
      and new_pos.x < @side_length \
      and new_pos.y < @side_length
  end
  def left
    new_pos = Point.new(@player_pos.x - 1, @player_pos.y)
    if (validate_new_pos(new_pos))
      place_player(new_pos)
    end
  end
  def right
    new_pos = Point.new(@player_pos.x + 1, @player_pos.y)
    if (validate_new_pos(new_pos))
      place_player(new_pos)
    end
  end
  def up
    new_pos = Point.new(@player_pos.x, @player_pos.y - 1)
    if (validate_new_pos(new_pos))
      place_player(new_pos)
    end
  end
  def down
    new_pos = Point.new(@player_pos.x, @player_pos.y + 1)
    if (validate_new_pos(new_pos))
      place_player(new_pos)
    end
  end

  def row_str(row)
    @board[row].join
  end
end

class Point
  def initialize(x, y)
    @x = x
    @y = y
  end

  attr_accessor :x
  attr_accessor :y
end

Curses.init_screen
begin
  Curses.noecho # don't show keys pressed
  Curses.crmode # don't require enter to accept keys
  Curses.nonl   # don't make newlines on key press
  Curses.curs_set(0)  # Invisible cursor

  window = Curses::Window.new(11, 11, Curses.lines - 15, 0)
  board = Board.new(11)

  for i in (0...11) do
    window.setpos(i, 0)
    window.addstr(board.row_str(i))
  end
  window.refresh

  window.setpos(1,0)
  window.refresh

  input = Curses::Key::UP
  while true
    input = window.getch
    if input == 'h'
      board.left
    end
    if input == 'j'
      board.down
    end
    if input == 'k'
      board.up
    end
    if input == 'l'
      board.right
    end
    if input == 'x'
      break
    end
    for i in (0...11) do
      window.setpos(i, 0)
      window.addstr(board.row_str(i))
    end
    window.refresh
  end

ensure
  Curses.close_screen
end


