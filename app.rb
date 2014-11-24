require 'sinatra'

$: << File.dirname(__FILE__)
require 'lib/radeyko'
require 'lib/thin/server'
require 'lib/server'

class RadeykoApp < Sinatra::Base

  configure do
    set :threaded, false
    set :logging, true
  end

  def self.root
    File.dirname(__FILE__)
  end

end

require 'models/init'
require 'routes/init'








