class Source

  attr_reader :channel, :buffer

  def initialize(host, port, channel)
    @host = host
    @port = port
    @channel = channel
    @source_channel = EM::Channel.new
    @buffer = Buffer.new
    subscribe_to_source_channel
  end

  def subscribe_to_source_channel
    @source_channel.subscribe do |data|
      @channel.push(data)
      @buffer.push(data)
    end
  end

  def play
    start_server
  end

  def start_server
    EM.start_server @host, @port, Server, @source_channel
  end

  class Server < EM::Connection

    def initialize(channel)
      p '============= Init connection ================='
      @channel = channel
    end

    def post_init
      puts "-- someone connected to the echo server!"
    end

    #"SOURCE /channels/input HTTP/1.0\r\nAuthorization: Basic Og==\r\nUser-Agent: libshout/2.3.1\r\nContent-Type: audio/mpeg\r\nice-name: test\r\nice-public: 1\r\nice-url: http://www.mixxx.org\r\nice-genre: Live Mix\r\nice-audio-info: bitrate=128\r\nice-description: \r\n\r\n"

    def receive_data(data)

      if data.match 'SOURCE'
        p data
        send_data("HTTP 200 OK\r\n\r\n")
      else
        # require 'pry'; binding.pry
        p data.size
        @channel.push(data.bytes)
      end
    end

    def unbind
      puts "-- someone disconnected from the echo server!"
    end

  end


end