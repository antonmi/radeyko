module Streams
  class Base

    attr_reader :data_channel, :info_channel, :connections_channel, :buffer
    attr_accessor :stream_title

    def chunk_size
      24576
    end

    def initialize(data_channel, info_channel, initial_data = [])
      @data_channel = data_channel
      @info_channel = info_channel
      @connections_channel = EM::Channel.new
      @buffer = Buffer.new
      @data = initial_data
      init_handlers
    end

    def init_handlers
      @data_channel.subscribe do |data|
        @data += data
        prepare_and_send!
      end
      @info_channel.subscribe do |data|
        handle_info(data)
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

    def handle_info(data)
      @stream_title = data[:track][:title]
    end

  end
end