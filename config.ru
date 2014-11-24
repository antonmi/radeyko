require 'eventmachine'
require 'thin'

root = ::File.dirname(__FILE__)
require ::File.join( root, 'app' )

def run(opts)
  EM.run do
    # require 'pry'; binding.pry
    server  = opts[:server] || 'thin'
    host    = opts[:host]   || '127.0.0.1'
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

run app: RadeykoApp.new