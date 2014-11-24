class Player

  attr_reader :status, :channel, :buffer

  def initialize(playlist, channel)
    @playlist = playlist
    @channel = channel
    @buffer = Buffer.new
    @status = :initialize
  end

  def play
    @status = :play
    @play_started_at = Time.now
    @data_got_at = Time.now
    @start_byte_number = 0

    @heart_bit = EM::PeriodicTimer.new(1) do
      play_next_interval
    end

  end

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

  def stop
    @status = :stop
    @heart_bit.cancel
  end

end