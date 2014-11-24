require 'eventmachine'
require 'thin'
root = ::File.dirname(__FILE__)
require ::File.join( root, 'app' )

require 'pry'; binding.pry
