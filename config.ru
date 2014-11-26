require 'eventmachine'
require 'thin'
require 'pry'

root = ::File.dirname(__FILE__)
require ::File.join( root, 'app' )

def run(opts)
  EM.run do
    server  = opts[:server] || 'thin'
    host    = opts[:host]   || '0.0.0.0'
    port    = opts[:port]   || '3000'
    web_app = opts[:app]

    dispatch = Rack::Builder.app do
      map '/' do
        run web_app
      end
    end

    unless ['thin', 'hatetepe', 'goliath'].include? server
      raise "Need an EM webserver, but #{server} isn't"
    end

    Rack::Server.start(app: dispatch, server: server, Host: host, Port: port)

    Radeyko.start!
  end
end
require 'pry'; binding.pry
run app: RadeykoApp.new