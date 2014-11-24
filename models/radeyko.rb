class Radeyko

  def self.start!
    playlist = Playlist.from_dir("/home/antonmi/Dropbox/Music/Перкалаба")
    channel = Channel.new('test', playlist)
    channel.player.play
    Channel.channels.merge!(channel.name => channel)

    100.times do |i|
      playlist = Playlist.from_dir("/home/antonmi/Dropbox/Music/Перкалаба")
      channel = Channel.new("test#{i}", playlist)
      channel.player.play
      Channel.channels.merge!(channel.name => channel)
    end
  end
end
