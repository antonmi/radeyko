class RadeykoApp < Sinatra::Base

  get '/streams/:id' do
    channel = Channel.channels[params[:id]]
    headers channel.stream.headers
    stream(:keep_open) do |out|
      channel.add_client(out)
    end
  end



end