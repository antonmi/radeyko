class RadeykoApp < Sinatra::Base

  get '/streams/:id' do
    channel = Channel.channels[params[:id]]
    if request.env['HTTP_ICY_METADATA']
      stream = channel.icy_stream
    else
      stream = channel.http_stream
    end

    headers stream.headers
    stream(:keep_open) do |out|
      channel.subscribe_client(stream, out)
    end
  end



end