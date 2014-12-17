require 'sinatra'
require "sinatra/json"
require 'em-http-request'

$: << File.dirname(__FILE__)
require 'lib/config/api_creds'
require 'lib/thin/server'

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









