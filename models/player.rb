class Player

  attr_reader :status, :channel, :buffer, :info_channel

  def initialize(playlist, channel, info_channel = EM::Channel.new)
    @playlist = playlist
    @channel = channel
    @info_channel = info_channel
    @loop = true
    @buffer = Buffer.new
    @status = :initialize
  end

  def play
    return if :status == :play
    @play_started_at = Time.now
    @data_got_at = Time.now

    if @status == :initialize || @status == :stop
      @start_byte_number = 0
    end

    @heart_bit = EM::PeriodicTimer.new(1) do
      play_next_interval
    end
    @status = :play
  end

  def stop
    @buffer = Buffer.new
    @heart_bit.cancel
    @status = :stop
  end

  def pause
    @heart_bit.cancel
    @play_paused_at = Time.now
    @status = :pause
  end

  def next
    self.start_byte_number = @playlist.next_track_start_byte(@start_byte_number)
  end

  def prev
    self.start_byte_number = @playlist.prev_track_start_byte(@start_byte_number)
  end

  def fwd
    self.start_byte_number = @start_byte_number + @playlist.rewind_bytes_count(@start_byte_number, 5)
  end

  def rev
    self.start_byte_number = @start_byte_number - @playlist.rewind_bytes_count(@start_byte_number, 5)
  end

  def info
    { player: player_info, track: track_info }
  end

  def start_byte_number=(value)
    @start_byte_number = value
    @start_byte_number = 0 if @start_byte_number < 0
    if @start_byte_number >= @playlist.bytesize && @loop
      @start_byte_number = 0
    end
  end

  private

  def play_next_interval
    time = Time.now - @data_got_at
    @data_got_at += time
    @current_track = @playlist.current_track(@start_byte_number)

    current_data_dfr = @playlist.current_data_dfr(@start_byte_number, time)
    current_data_dfr.callback do |data|
      @current_data = data
      self.start_byte_number = @start_byte_number + @current_data.size
      push_data
    end
  end

  def push_data
    @channel.push(@current_data)
    @buffer.push(@current_data)
    p info
    @info_channel.push(info)
  end

  def player_info
    {
        status: @status,
        play_started_at: @play_started_at,
        current_track_time: @playlist.current_track_time(@start_byte_number).to_i
    }
  end

  def track_info
    return {} unless @current_track
    {
        title: @current_track.title,
        bitrate: @current_track.bitrate,
        length: @current_track.length.to_i
    }
  end

end