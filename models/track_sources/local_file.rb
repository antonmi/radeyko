class TrackSources::LocalFile

  attr_reader :path

  def initialize(path)
    @path = path
  end

  def read_data_dfr(size, offset, data_pos)
    dfr = EM::DefaultDeferrable.new
    EM::next_tick { dfr.succeed read_data(size, offset, data_pos) }
    dfr
  end

  def read_data(size, offset, data_pos)
    string = File.read(@path, size, data_pos + offset)
    string ? string.bytes : [] #TODO fix this.
  end

end