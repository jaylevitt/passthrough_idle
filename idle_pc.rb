require 'rubygems'
require 'nestful'
require 'Win32API'
require 'trollop'

DEBUG = true
INTERVAL = 1
SLACK = 10

KEYEVENTF_KEYDOWN = 0
KEYEVENTF_KEYUP = 2

KEY_RALT = 165

def main
  opts = Trollop::options do
    opt :host, "idle server host", :type => :string, :required => true
    opt :port, "idle server port", :type => :int, :default => 12389
  end

  url = "http://#{opts[:host]}:#{opts[:port]}/"

  idle = 0 # there must be a more idiomatic way to do this
  
  loop do
    puts Time.now if DEBUG
    idle = Nestful.get(url).to_i
    
    puts "Idle: #{idle}" if DEBUG

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
