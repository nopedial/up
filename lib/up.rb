module Up
  Directory = File.expand_path File.join File.dirname(__FILE__), '../'
  require 'asetus'
  require 'logger'
  require 'sinatra'
  require 'thin'
  require 'json'
  require 'yaml'
  require 'haml'
  require 'up/web'
end
