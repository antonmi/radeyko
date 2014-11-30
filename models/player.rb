class Player

  attr_reader :status, :channel, :buffer

  def initialize(playlist, channel)
    @playlist = playlist
    @channel = channel
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

  def next_track
    @start_byte_number = @playlist.next_track_start_byte(@start_byte_number)
  end

  def prev_track
    @start_byte_number = @playlist.prev_track_start_byte(@start_byte_number)
  end



  private

  def play_next_interval
    time = Time.now - @data_got_at
    @data_got_at += time
    data = @playlist.current_data(@start_byte_number, time)
    track = @playlist.current_track(@start_byte_number)
    @start_byte_number += data.size
    p "#{Time.now - @play_started_at}. Track: #{track.info.tag['title']}. Data size: #{data.size}"

    @channel.push(data)
    @buffer.push(data)
  end


end