playlist = Playlist.from_dir("#{RadeykoApp.root}/spec/data")
channel = Channel.new('test', playlist)

Channel.channels.merge!(channel.name => channel)

require_relative 'test_model'