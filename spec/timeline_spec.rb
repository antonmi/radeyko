require 'spec_helper'

describe Timeline do

  let(:dir) { RSpec.configuration.data_path }
  let(:playlist) { Playlist.from_dir(dir) }
  let(:timeline) { playlist.timeline }


  describe 'track_index' do
    #[3153631, 7889655, 14302113, 18574829, 22987353, 28566610, 33332100, 40374005, 44861761, 48165857, 51753329]

    it 'should get 0 track' do
      expect(timeline.track_index(0)).to eq(0)
    end

    it 'should get 0 track' do
      expect(timeline.track_index(3153630)).to eq(0)
    end

    it 'should get 1 track' do
      expect(timeline.track_index(3153631)).to eq(1)
    end

    it 'should get nil' do
      expect(timeline.track_index(51753330)).to eq(11)
    end
  end


  describe 'offset_for_track' do
    #[3153631, 7889655, 14302113, 18574829, 22987353, 28566610, 33332100, 40374005, 44861761, 48165857, 51753329]
    #[131.39591666666666, 328.724875, 595.90525, 773.9297083333333, 957.7795, 1190.2431666666666, 1388.799875, 1682.2072083333333, 1869.1916666666666, 2006.8569583333333, 2156.329583333333]

    it 'should get offset for 0 track' do
      expect(timeline.offset_for_track(0)).to eq(0)
    end

    it 'should get offset for 0 track' do
      expect(timeline.offset_for_track(1_000_000)).to eq(1_000_000)
    end

    it 'should get offset for 1 track' do
      expect(timeline.offset_for_track(3153631)).to eq(0)
    end

    it 'should get offset for 1 track' do
      offset = 5_000_000 - 3153631
      expect(timeline.offset_for_track(5_000_000)).to eq(offset)
    end

  end

end