#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'

$idle_seconds = 0

get '/' do
  "Last known idle time: #{$idle_seconds}\n"
end

put '/:idle' do
  $idle_seconds = params[:idle]
  "Idle time set: #{$idle_seconds}\n"
end
  
