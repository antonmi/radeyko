require 'eventmachine'


class Server < EM::Connection

  def initialize
    p '============= Init connection ================='
  end

  def post_init
    puts "-- someone connected to the echo server!"
  end

  def receive_data(data)
    p 'received data'
    send_data("HTTP 200 OK\r\n\r\n")
    p data
  end

  def unbind
    puts "-- someone disconnected from the echo server!"
  end

end

EM.run do
  EM.start_server "0.0.0.0", 3001, Server
end