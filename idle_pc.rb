require 'socket'
require 'Win32API'

IDLE_PORT = 12389
IDLE_SERVER = "example.com"
DEBUG = true
INTERVAL = 1
SLACK = 10
MAX_REPEATS = 3

KEYEVENTF_KEYDOWN = 0
KEYEVENTF_KEYUP = 2

KEY_RALT = 165

def main
  s = TCPSocket.open(IDLE_SERVER, IDLE_PORT)
  s.gets # throw away greeting

  loop do
    puts Time.now if DEBUG
    s.puts "pull"
    last_idle = idle
    idle = s.gets.to_i
    
    if last_idle == idle
      repeated += 1
    else
      repeated = 0
    end
    
    puts "Idle: #{idle}, repeated #{repeated}" if DEBUG

    if repeated == MAX_REPEATS
      abort
    end
      
    # This could be smarter... trouble is we can't assume that the 
    # mac's clock is in sync with ours, or that its sleep interval
    # is related to ours

    if idle < SLACK
      fake_activity
    end

    sleep INTERVAL
  end  
end

def fake_activity
  puts "faking activity..." if DEBUG

  # from http://bitbucket.org/undees/idgtr-code/src/tip/early%5Fsuccess/windows%5Fbasics.rb
  # and http://stackoverflow.com/questions/1175803/how-to-automate-a-keystroke-using-win32-and-ruby

  keybd_event = Win32API.new 'user32', 'keybd_event', ['I', 'I', 'L', 'L'], 'V'
  keybd_event.call KEY_RALT, 0, KEYEVENTF_KEYUP, 0
end

main