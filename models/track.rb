require 'mp3info'
class Track

  attr_reader :info, :index, :data_pos, :size, :length

  def initialize(track_source, index)
    @track_source = track_source
    @index = index

    size_dfr = track_source.size_dfr
    size_dfr.callback { |size| p 'size_drf'; @size = size}

    header_dfr = track_source.read_data_dfr(300_000, 0, 0)

    header_dfr.callback do |header_data|
      p 'header_dfr'
      mp3_data = StringIO.new(header_data.pack('c*'))
      Mp3Info.open(mp3_data) { |mp3info|  @info = mp3info }
      puts '='*100
      @size = track_source.size
      @data_pos = @info.instance_variable_get(:@first_frame_pos)
      @length =  data_size.to_f * 8 / bitrate / 1000
    end
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