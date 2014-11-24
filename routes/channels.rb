class RadeykoApp < Sinatra::Base

  get '/channels/:name/play' do
    channel = Channel.channels[params[:name]]
    channel.player.play
    status 200
  end


end