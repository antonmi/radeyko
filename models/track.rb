require 'mp3info'
class Track

  attr_reader :info, :path, :index, :data_pos, :size

  def initialize(path, index)
    @path = path
    @index = index
    Mp3Info.open(path) do |mp3info|
      @info = mp3info
      @info.instance_variable_get(:@io).close
    end
    @size = @info.instance_variable_get(:@io_size)
    @data_pos = @info.instance_variable_get(:@first_frame_pos)
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

  def read_data(size, offset)
    string = File.read(@path, size, data_pos + offset)
    string ? string.bytes : [] #TODO fix this.
  end

  def size_for_time(time)
    size = data_size / length * time
    size < data_size ? size : data_size
  end

  def time_for_size(size)
    length / data_size * size
  end

end