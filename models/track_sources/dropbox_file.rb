require 'dropbox_sdk'
class TrackSources::DropboxFile

  attr_reader :path, :client

  def initialize(path)
    @path = path
    access_token = Config::ApiCreds.dropbox[:access_token]
    @client = DropboxClient.new(access_token)
  end

  def read_data_dfr(size, offset, data_pos)
    dfr = EM::DefaultDeferrable.new
    start = data_pos + offset
    finish = start + size
    opts = { head: {'Range' => "bytes=#{start}-#{finish.to_i}" } }
    http = EventMachine::HttpRequest.new(@media['url']).get(opts)
    http.callback { dfr.succeed(http.response.bytes) }
    dfr
  end

  def size_dfr
    dfr = EM::DefaultDeferrable.new
    EM.defer do
      get_media_metadata
      dfr.succeed size
    end
    dfr
  end

  def get_media_metadata
    @media = @client.media(@path)
    @metadata = @client.metadata(@path)
  end

  def size

    @metadata['bytes']
  end

end