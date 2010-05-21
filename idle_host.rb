#!/usr/bin/ruby
require 'gserver'

IDLE_PORT = 4244

class IdleServer < GServer
    def initialize(port=IDLE_PORT, *args)
      super(port, *args)
    end
    
    def serve(io)
      idle_raw = `/usr/sbin/ioreg -c IOHIDSystem`.grep(/HIDIdleTime/)
      idle_time = (idle_raw.last.split.last.to_i) / 1_000_000_000
      io.puts "#{idle_time}\n"
    end
  end
  
      
def main
  server = IdleServer.new
  server.start
  server.join  
end

main
