#!/usr/bin/env ruby
require 'gserver'

IDLE_PORT = 12389

class IdleServer < GServer
  def initialize(*args)
    super(*args)

    @@idle_seconds = 0
  end

  def serve(io)
    io.puts("passthrough_idle server 0.1")

    loop do
      line = io.readline
      case line
      when /PULL/i 
        io.puts "Last known idle time: #{@@idle_seconds}"
      when /SET ([0-9]+)/i
        @@idle_seconds = $1
        io.puts "Idle time set: #{@@idle_seconds}"
      when /QUIT/i
        break
      else
        io.puts "Unknown command"
      end
    end

  end
end

server = IdleServer.new(IDLE_PORT, "0.0.0.0")
server.start
server.join
