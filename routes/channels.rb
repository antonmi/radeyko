class RadeykoApp < Sinatra::Base

  get '/channels/:name/player/:command' do
    channel = Channel.channels[params[:name]]
    if channel.perform_command(params[:command])
      status 200
    else
      status 404
    end
  end

  get '/channels/:name/info' do
    channel = Channel.channels[params[:name]]
    json channel.info
  end





end

