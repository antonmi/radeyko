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
    [0]
  end

end