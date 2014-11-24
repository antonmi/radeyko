class Timeline

  attr_reader :times, :bytes

  def initialize(tracks)
    @times = []
    @bytes = []
    time, byte = 0, 0
    tracks.each do |track|
      time += track.length
      byte += track.data_size
      @times << time
      @bytes << byte
    end
    @bytes_reversed = @bytes.reverse
    @times_reversed = @times.reverse
  end

  def track_index(byte)
    byte = @bytes_reversed.detect { |b| byte >= b }
    if byte
      @bytes.index(byte) + 1
    else
      0
    end
  end

  def offset_for_track(start_byte_number)
    byte = @bytes_reversed.detect { |b|  b <= start_byte_number }
    if byte
      start_byte_number - byte
    else
      start_byte_number
    end
  end

end