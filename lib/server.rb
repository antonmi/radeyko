class Server
  # "ICY 200 OK\r\n",
  def self.headers
    {
        "icy-notice1" => "hello",
        "icy-notice2" => "world",
        "icy-name" => "Radeyko",
        "icy-genre" => "Various",
        "icy-url" => "http://localhost:3000/",
        "Content-Type" => "audio/mpeg",
        "icy-pub" => "1",
        "icy-metaint" => "#{Server.stream.chunk_size}"#,
        # "icy-br" => "Server.player"
    }
  end

  def self.clients
    @clients ||= {}
  end

  def self.chunk
    @chunk
  end

  def self.next_chunk!
    bytes = player.next_chunk << 0
    @chunk = bytes.pack('C*')
  end

  def self.playlist
    @playlist ||= Playlist.from_dir("#{RadeykoApp.root}/spec/data")
  end

  def self.stream
    @stream ||= Stream.new('test')
  end

  def self.player
    # @player ||= Mp3Player.new('../data/test.mp3')
    @player ||= Player.new(playlist, stream.player_channel)
  end
end
