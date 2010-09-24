#!/usr/bin/ruby
require 'rubygems'
require 'nestful'
require 'trollop'

INTERVAL = 1
DEBUG = TRUE

def main
  opts = Trollop::options do
    opt :host, "idle server host", :type => :string, :required => true
    opt :port, "idle server port", :type => :int, :default => 12389
  end

  url = "http://#{opts[:host]}:#{opts[:port]}"
  
  loop do
    idle = `/usr/local/bin/idler`.to_i
    puts "#{Time.now} Setting idle: #{url}/#{idle}" if DEBUG
    Nestful.put "#{url}/#{idle}", :format => :form

    sleep INTERVAL
  end
end
  
main