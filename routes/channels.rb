class RadeykoApp < Sinatra::Base

  get '/channels/:name/play' do
    channel = Channel.channels[params[:name]]
    channel.player.play
    status 200
  end

  get '/channels/input' do
    EM.start_server "0.0.0.0", 3001, Server
  end


end

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