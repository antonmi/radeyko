class Streams::Icy < Streams::Base

  def headers
    {
        "icy-notice1" => "hello",
        "icy-notice2" => "world",
        "icy-name" => "Radeyko",
        "icy-genre" => "Various",
        "icy-url" => "http://localhost:3000/",
        "Content-Type" => "audio/mpeg",
        "icy-pub" => "1",
        "icy-metaint" => "#{chunk_size}"#,
        # "icy-br" => "Server.player"
    }
  end

  def stream_info_bytes
    size = info_string.bytesize
    return [0] if size.zero?
    blocks = size / 16 + 1
    zeros = blocks * 16 - size
    bytes = [blocks] + info_string.bytes + [0]*zeros
    bytes
  end

  def info_string
    if @stream_title
      "StreamTitle='#{@stream_title}';"
    else
      ''
    end
  end

end