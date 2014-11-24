require 'spec_helper'

describe Player do

  let(:dir) { RSpec.configuration.data_path }
  let(:playlist) { Playlist.from_dir(dir) }

  let(:stream) { Stream.new('test')}

  let(:player) { Player.new(playlist, stream.player_channel)}

  context 'heart_bit' do

    it '' do
      EM.run do
        player.play

        # EM::Timer.new(5) { stream.connection_channel.subscribe { |data| p "===#{data.size}"} }

        EM::Timer.new(1500) { player.stop; EM.stop }
      end


    end

  end

end