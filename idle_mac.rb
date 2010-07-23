#!/usr/bin/ruby
require 'rubygems'
require 'socket'
require 'trollop'

INTERVAL = 1
DEBUG = TRUE

def main
  opts = Trollop::options do
    opt :host, "idle server host", :type => :string, :required => true
    opt :port, "idle server port", :type => :int, :default => 12389
  end

  s = TCPSocket.open(opts[:host], opts[:port])
  
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