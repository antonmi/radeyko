class Radeyko

  def self.start!
    playlist = Playlist.from_dir("/home/antonmi/Dropbox/Music/Перкалаба")
    channel = Channel.new('test', playlist)
    channel.player.play
    Channel.channels.merge!(channel.name => channel)
  end
end
