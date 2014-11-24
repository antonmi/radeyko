class Buffer
  SIZE = 5

  def initialize(size = SIZE)
    @size = size
  end

  def data
    chunks.flatten
  end

  def chunks
    @chunks ||= []
  end

  def push(chunk)
    chunks << chunk
    chunks.shift if chunks.size > @size
  end
end