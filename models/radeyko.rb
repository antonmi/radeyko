class Radeyko

  def self.start!
    playlist = Playlist.from_dir("/home/antonmi/Dropbox/Music/Перкалаба")
    source = Player.new(playlist, EM::Channel.new)
    # source = Source.new('0.0.0.0', 3001, EM::Channel.new)

    channel = Channel.new('test', source)
    channel.source.play
    Channel.channels.merge!(channel.name => channel)

    # 100.times do |i|
    #   playlist = Playlist.from_dir("/home/antonmi/Dropbox/Music/Перкалаба")
    #   channel = Channel.new("test#{i}", playlist)
    #   channel.player.play
    #   Channel.channels.merge!(channel.name => channel)
    # end
  end
end
