class Playlist

  attr_reader :file_paths, :tracks, :timeline

  def initialize(file_paths)
    @file_paths = file_paths
    @tracks = []
    file_paths.each_with_index do |path, index|
      @tracks << Track.new(path, index)
    end
    @timeline = Timeline.new(@tracks)
    @timeline.bytes
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

  def next_track_start_byte(start_byte_number)
    index = @timeline.track_index(start_byte_number)
    @timeline.bytes[index]
  end

  def prev_track_start_byte(start_byte_number)
    index = @timeline.track_index(start_byte_number)
    return 0 if index < 2
    @timeline.bytes[index - 2]
  end

  def rewind_bytes_count(start_byte_number, time)
    track = current_track(start_byte_number)
    track.size_for_time(time)
  end

  def current_track_time(start_byte_number)
    track = current_track(start_byte_number)
    track.time_for_size(@timeline.offset_for_track(start_byte_number))
  end

end