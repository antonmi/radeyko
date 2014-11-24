class Channel

  attr_reader :player, :name, :stream

  def self.channels
    @channels ||= {}
  end

  def clients
    @clients ||= {}
  end

  def initialize(name, playlist)
    @name = name
    @stream = Stream.new
    @player = Player.new(playlist, @stream.player_channel)
  end


  def add_client(out)
    @stream.buffer.chunks.each { |chunk| out << chunk }
    name = @stream.connections_channel.subscribe { |data| out << data }
    clients.merge!(out => name)
    out.callback { remove_client(out) }
    out.errback { remove_client(out) }
  end


  def remove_client(out)
    name = @clients.delete(out)
    @stream.connections_channel.unsubscribe(name)
  end







end