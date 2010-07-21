#!/usr/bin/ruby
require 'socket'

IDLE_PORT = 12389
IDLE_SERVER = "home.jay.fm"
INTERVAL = 1
DEBUG = TRUE

def main
  s = TCPSocket.open(IDLE_SERVER, IDLE_PORT)
  
  loop do
    idle = `/usr/local/bin/idler`.to_i
    puts "#{Time.now} Setting idle: #{idle}" if DEBUG

    begin 
      s.puts "set #{idle}\n"
    rescue
      puts "#{Time.now} Reopening socket"
      s.close
      s = TCPSocket.open(IDLE_SERVER, IDLE_PORT)
    end

    sleep INTERVAL
  end
end
  
main