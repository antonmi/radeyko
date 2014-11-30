module Streams
  class Base

    attr_reader :player_channel, :connections_channel, :buffer

    def chunk_size
      24576
    end

    def initialize(player_channel, initial_data = [])
      @player_channel = player_channel
      @connections_channel = EM::Channel.new
      @buffer = Buffer.new
      @data = initial_data
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
        packed_data = data.pack('C*')
        connections_channel.push(packed_data)
        @buffer.push(packed_data)
      end
    end

    def clear_buffer
      @buffer = Buffer.new
    end

  end
end