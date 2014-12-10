class Radeyko

  def self.start!
    # playlist = Playlist.from_dir("/home/antonmi/Dropbox/Music/Перкалаба")
    # playlist = Playlist.from_dir("/home/antonmi/Music/Перкалаба")

    playlist = Playlist.new([
                                "/music/Перкалаба/Перкалаба - We R The Beetles [Dirtyindie Mix].mp3",
                                "/music/Перкалаба/Перкалаба - 4 Танкиста.mp3",
                                "/music/Перкалаба/Перкалаба - Soledad (Qarpa Cover).mp3"
                            ])

    playlist.read_tracks_dfr.callback do
      source = Player.new(playlist, EM::Channel.new)
      # source = Source.new('0.0.0.0', 3001, EM::Channel.new)

      channel = Channel.new('test', source)
      channel.source.play
      Channel.channels.merge!(channel.name => channel)
    end

    # tick = proc { print '.'; EM.next_tick {tick.call} }
    # tick.call
    # 100.times do |i|
    #   playlist = Playlist.from_dir("/home/antonmi/Dropbox/Music/Перкалаба")
    #   channel = Channel.new("test#{i}", playlist)
    #   channel.player.play
    #   Channel.channels.merge!(channel.name => channel)
    # end
  end
end
