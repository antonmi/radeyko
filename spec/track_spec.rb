require 'spec_helper'

describe Track do

  let(:dir) { RSpec.configuration.data_path }
  let(:playlist) { Playlist.from_dir(dir) }

  describe "Get file's info" do

    let(:track) { playlist.tracks.first }

    it { expect(track.path).to eq("#{dir}/01 Dzieciuki - Muzhyckaja prauda.mp3") }

    context 'track info' do
      it { expect(track.bitrate).to eq(192) }
      it { expect(track.length.to_i).to eq(131) }
      it { expect(track.data_pos).to eq(40412) }
      it { expect(track.size).to eq(3194042) }
    end

    describe 'file data' do
      let(:track0_file_data) { File.open(track.path).read.bytes }

      let(:first_data_byte) { track0_file_data[track.data_pos]}
      let(:first_10_bytes) { track0_file_data[track.data_pos, 10]}
      let(:last_10_bytes) {track0_file_data[-10, 10] }

      describe 'read_data' do
        let(:first) { track.read_data(1, 0).first}
        let(:first10) { track.read_data(10, 0)}
        let(:last10) do
          offset = track.data_size - 11
          track.read_data(10, offset)
        end

        it { expect(first).to eq(first_data_byte) }
        it { expect(first10).to eq(first_10_bytes) }
        it { expect(last10).to eq(last_10_bytes) }

        describe 'boundaries' do
          it { expect(track.read_data(0, 0)).to be_empty }
          it { expect(track.read_data(1000, track.data_size - 11)).to eq(last_10_bytes) }
          it { expect { track.read_data(1000, track.data_size + 1) } .to raise_error }
        end
      end
    end

    describe 'size_for_time' do
      #3153631
      #131.39591666666666
      it { expect(track.size_for_time(130)).to be_between(3_000_000, track.data_size) }
      it { expect(track.size_for_time(track.length)).to eq(track.data_size) }
      it { expect(track.size_for_time(200)).to eq(track.data_size) }
    end

    describe 'time_for_size' do
      #3153631
      #131.39591666666666
      it { expect(track.time_for_size(3_000_000)).to be_between(124, 132) }
      it { expect(track.time_for_size(track.data_size)).to eq(track.length) }
    end

  end


end