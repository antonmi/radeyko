require 'mp3info'
class Track

  attr_reader :info, :index, :data_pos, :size

  def initialize(track_source, index)
    @track_source = track_source
    @index = index

    header = track_source.read_data(1_000_000, 0, 0).pack('c*')
    # Mp3Info.open(StringIO.new(header)) do |mp3info|
    Mp3Info.open(track_source.path) do |mp3info|
      @info = mp3info
      @info.instance_variable_get(:@io).close
    end
    puts '='*100
    # require 'pry'; binding.pry
    @size = @info.instance_variable_get(:@io_size)
    @data_pos = @info.instance_variable_get(:@first_frame_pos)
    p @size - @data_pos
    p @info.length * bitrate * 1000 / 8
    require 'pry'; binding.pry
  end

  def path
    @track_source.path
  end

  def title
    @info.tag['title']
  end

  def bitrate
    @info.bitrate
  end

  def length
    @info.length
  end

  def data_size
    @size - @data_pos + 1
  end

  def read_data_dfr(size, offset)
    @track_source.read_data_dfr(size, offset, data_pos)
  end

  def size_for_time(time)
    size = data_size / length * time
    size < data_size ? size : data_size
  end

  def time_for_size(size)
    length / data_size * size
  end

end