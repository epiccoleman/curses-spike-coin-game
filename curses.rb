require 'curses'

Curses.init_screen
begin
  Curses.noecho # don't show keys pressed
  Curses.crmode # don't require enter to accept keys
  Curses.nonl   # don't make newlines on key press
  Curses.curs_set(0)  # Invisible cursor

  window = Curses::Window.new(2, 40, Curses.lines - 5, 0)
  window.setpos(0,0)
  window.addstr("Hello World")

  disp_string = "---------*----------"
  disp_arr = disp_string.split('')

  window.setpos(1,0)
  window.addstr(disp_string)
  window.refresh
  input = Curses::Key::UP
  while true
    input = window.getch
    if input == 'j' or input == 'h'
      disp_string = disp_string.split('').rotate.join
      window.setpos(1,0)
      window.addstr(disp_string)
    end
    if input == 'k' or input == 'l'
      disp_string = disp_string.split('').rotate(-1).join
      # window.addstr(disp_string)
      window.setpos(1,0)
      window.addstr(disp_string)
    end
    if input == 'x'
      break
    end
    window.refresh
  end
ensure
  Curses.close_screen
end


