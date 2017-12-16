require 'rubygems'
require 'bundler'
Bundler.require

require './app'

run Rack::URLMap.new( {
  "/cache" => Rack::Directory.new( "cache" ),
  "/" => WebApp.new
} )
