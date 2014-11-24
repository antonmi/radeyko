class Playlist

  attr_reader :file_paths, :tracks, :timeline

  def initialize(file_paths)
    @file_paths = file_paths
    @tracks = []
    file_paths.each_with_index do |path, index|
      @tracks << Track.new(path, index)
    end
    @timeline = Timeline.new(@tracks)
  end

  def self.from_dir(path)
    file_paths = Dir["#{path}/**/*.mp3"].shuffle
    new(file_paths)
  end

  def current_data(start_byte_number, time)
    byte_number = start_byte_number
    data = []
    while time > 0.1
      track = current_track(byte_number)
      size = track.size_for_time(time)
      offset = @timeline.offset_for_track(byte_number)
      track_data = track.read_data(size, offset)
      byte_number += track_data.size + 1
      time -= track.time_for_size(track_data.size)
      data += track_data
    end
    data
  end

  def current_track(start_byte_number)
    index = @timeline.track_index(start_byte_number)
    @tracks[index]
  end

end