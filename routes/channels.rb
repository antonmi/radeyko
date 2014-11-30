class RadeykoApp < Sinatra::Base

  get '/channels/:name/:command' do
    channel = Channel.channels[params[:name]]
    if channel.perform_command(params[:command])
      status 200
    else
      status 404
    end
  end




end

