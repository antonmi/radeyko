class Streams::Http < Streams::Base

  def headers
    {
        "Content-Type" => "audio/mpeg",
    }
  end

  def stream_info_bytes
    []
  end
end