require 'curses'

class Board
  def initialize(x_length, y_length)
    @x_length = x_length
    @y_length = y_length
    @score = 0

    @player_pos = Point.new(@x_length / 2, @y_length / 2)

    generate_coins
    update_board
  end

  def clear_board
    @board = Array.new(@y_length) { Array.new(@x_length, '.') }
  end

  def update_board
    clear_board
    place_player
    place_coins
  end

  def place_player
    @board[@player_pos.y][@player_pos.x] = 'X'
  end

  def place_coin(point)
    @board[point.y][point.x] = '0'
  end

  def generate_coins
    @coins = [ Point.new(@player_pos.x + 4, @player_pos.y),
               Point.new(@player_pos.x, @player_pos.y - 2)  ]
  end

  def place_coins
    for coin in @coins do
      place_coin coin
    end
  end

  def validate_new_pos(new_pos)
    new_pos.x >= 0 \
      and new_pos.y >= 0 \
      and new_pos.x < @x_length \
      and new_pos.y < @y_length
  end
  def left
    new_pos = Point.new(@player_pos.x - 1, @player_pos.y)
    if (validate_new_pos(new_pos))
      @player_pos = new_pos
    end
  end
  def right
    new_pos = Point.new(@player_pos.x + 1, @player_pos.y)
    if (validate_new_pos(new_pos))
      @player_pos = new_pos
    end
  end
  def up
    new_pos = Point.new(@player_pos.x, @player_pos.y - 1)
    if (validate_new_pos(new_pos))
      @player_pos = new_pos
    end
  end
  def down
    new_pos = Point.new(@player_pos.x, @player_pos.y + 1)
    if (validate_new_pos(new_pos))
      @player_pos = new_pos
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

  window_height = Curses.lines
  window_width = Curses.cols
  window = Curses::Window.new(window_height, window_width, 0, 0)

  game_board_height = window_height - 16
  game_board_width = window_width - 6
  board = Board.new(game_board_width, game_board_height)

  board.update_board
  for i in (0...game_board_height) do
    window.setpos(i + 3, 3)
    window.addstr(board.row_str(i))
  end
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
    board.update_board
    for i in (0...game_board_height) do
      window.setpos(i + 3, 3)
      window.addstr(board.row_str(i))
    end
    window.refresh
  end

ensure
  Curses.close_screen
end


