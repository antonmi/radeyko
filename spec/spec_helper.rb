lib_dir_path = File.expand_path('../lib', __FILE__)
$: << lib_dir_path

require 'pry'
require 'eventmachine'

require 'playlist'
require 'track'
require 'timeline'
require 'player'
require 'stream'

RSpec.configure do |c|
  c.add_setting :data_path
  c.data_path = File.expand_path('../data', __FILE__)
end
