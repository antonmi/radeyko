require 'spec_helper'

describe Playlist do

  let(:dir) { RSpec.configuration.data_path }
  let(:playlist) { Playlist.from_dir(dir) }

  describe 'Playlist.from_dir' do
    it { expect(playlist.tracks ).to_not be_empty }
  end

  describe 'current_track' do
    #[3153631, 7889655, 14302113, 18574829, 22987353, 28566610, 33332100, 40374005, 44861761, 48165857, 51753329]
    #[131.39591666666666, 328.724875, 595.90525, 773.9297083333333, 957.7795, 1190.2431666666666, 1388.799875, 1682.2072083333333, 1869.1916666666666, 2006.8569583333333, 2156.329583333333]

    it { expect(playlist.current_track(0).index).to eq(0) }
    it { expect(playlist.current_track(3_000_000).index).to eq(0) }
    it { expect(playlist.current_track(5_000_000).index).to eq(1) }
    it { expect(playlist.current_track(5_000_000_000)).to be_nil }


  end

  describe 'current_data' do

    #[3153631, 7889655, 14302113, 18574829, 22987353, 28566610, 33332100, 40374005, 44861761, 48165857, 51753329]
    #[131.39591666666666, 328.724875, 595.90525, 773.9297083333333, 957.7795, 1190.2431666666666, 1388.799875, 1682.2072083333333, 1869.1916666666666, 2006.8569583333333, 2156.329583333333]

    context '1 file' do
      let(:start_byte_number) { 1_000_00 }
      let(:time) { 100 }

      let(:track) { playlist.tracks.first }
      let(:track_file_data) { File.open(track.path).read.bytes }

      let(:current_data) { playlist.current_data(start_byte_number, time)}

      it { expect(current_data).to_not be_empty }
      it { expect(current_data.size < track_file_data.size).to be true }
    end

    context '3 files' do
      let(:start_byte_number) { 1_000_000 }
      let(:time) { 400 }
      let(:track1) { playlist.tracks.first }
      let(:track2) { playlist.tracks.last }
      let(:track1_file_data) { File.open(track1.path).read.bytes }
      let(:track2_file_data) { File.open(track2.path).read.bytes }

      let(:current_data) { playlist.current_data(start_byte_number, time)}

      it { expect(current_data).to_not be_empty }
    end

  end

end