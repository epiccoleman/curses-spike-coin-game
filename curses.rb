require 'curses'

class Board
  def initialize(x_length, y_length)
    @x_length = x_length
    @y_length = y_length
    @score = 0
    @coins = []

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

    if player_on_coin? then collect_coin end
    place_coins

  end

  def place_player
    @board[@player_pos.y][@player_pos.x] = 'X'
  end

  def place_coin(point)
    @board[point.y][point.x] = '0'
  end

  def generate_coins
    for x in (0...@x_length) do
      for y in (0...@y_length) do
        if( rand > 0.95 )
          @coins.push Point.new(x, y)
        end
      end
    end
  end

  def place_coins
    for coin in @coins do
      place_coin coin
    end
  end

  def player_on_coin?
    @coins.any? { |coin| coin == @player_pos }
  end

  def collect_coin
    @coins.select! { |coin| coin != @player_pos }
    @score += 1
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

  attr_reader :score
end

class Point
  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    other.class == self.class \
      && other.x == self.x \
      && other.y == self.y
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
  score_line = window_height - 10
  board = Board.new(game_board_width, game_board_height)

  window.setpos(score_line, 3)
  window.addstr("Score: #{board.score}")
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
    window.setpos(score_line, 3)
    window.addstr("Score: #{board.score}")
    window.refresh
  end

ensure
  Curses.close_screen
end


