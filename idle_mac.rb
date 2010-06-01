#!/usr/bin/ruby
require 'socket'

IDLE_PORT = 12389
IDLE_SERVER = "home.jay.fm"
INTERVAL = 1
DEBUG = FALSE

def main
  s = TCPSocket.open(IDLE_SERVER, IDLE_PORT)
  
  loop do
    idle = `./idler`.to_i
    s.puts "set #{idle}\n"
    puts "Setting idle: #{idle}" if DEBUG
    sleep INTERVAL
  end
end

main