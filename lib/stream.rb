class Stream

  attr_reader :player_channel, :connections_channel, :buffer

  def chunk_size
    24576
  end

  def headers
    {
        "icy-notice1" => "hello",
        "icy-notice2" => "world",
        "icy-name" => "Radeyko",
        "icy-genre" => "Various",
        "icy-url" => "http://localhost:3000/",
        "Content-Type" => "audio/mpeg",
        "icy-pub" => "1",
        "icy-metaint" => "#{chunk_size}"#,
        # "icy-br" => "Server.player"
    }
  end

  def initialize
    @player_channel = EM::Channel.new
    @connections_channel = EM::Channel.new
    @buffer = Buffer.new
    @data = []
    init_handler
  end

  def init_handler
    @player_channel.subscribe do |data|
      @data += data
      prepare_and_send!
    end
  end

  def prepare_and_send!
    while @data.size > chunk_size
      data = @data.shift(chunk_size)
      data += stream_info_bytes
      p data.size
      packed_data = data.pack('C*')
      connections_channel.push(packed_data)
      @buffer.push(packed_data)
    end
  end

  def stream_info_bytes
    [0]
  end

  class Buffer
    SIZE = 5

    def chunks
      @chunks ||= []
    end

    def push(chunk)
      chunks << chunk
      chunks.shift if chunks.size > SIZE
    end
  end


end