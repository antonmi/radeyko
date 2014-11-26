class Channel

  attr_reader :source, :name, :stream

  def self.channels
    @channels ||= {}
  end

  def available_streams
    @available_streams ||= {}
  end

  def clients
    @clients ||= {}
  end

  def initialize(name, source)
    @name = name
    @source = source
  end

  def subscribe_client(stream, out)
    stream.buffer.chunks.each { |chunk| out << chunk }
    name = stream.connections_channel.subscribe { |data| out << data }
    clients.merge!(out => name)
    out.callback { remove_client(stream, out) }
    out.errback { remove_client(stream, out) }
    p '='*100
    p available_streams.keys
    p "clients: #{clients.size}"
  end

  def icy_stream
    get_stream(Streams::Icy)
  end

  def http_stream
    get_stream(Streams::Http)
  end

  def get_stream(klass)
    stream = available_streams[klass]
    return stream if stream
    stream = klass.new(@source.channel, @source.buffer.data)
    available_streams.merge!(stream.class => stream)
    stream
  end


  def remove_client(stream, out)
    name = @clients.delete(out)
    stream.connections_channel.unsubscribe(name)
  end







end