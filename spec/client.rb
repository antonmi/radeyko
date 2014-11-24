require 'eventmachine'
require 'em-http-request'
class Client < EM::Connection

  def post_init
    puts "sending request to server"
    send_data "GET / HTTP/1.1\r\nHost: www.baidu.com\r\nConnection: close\r\n\r\n"
  end

  def receive_data(data)
    puts "recieved data"
    puts "size: #{data.size}"
    puts "first: #{data[0]}, last: #{data[data.size - 1]}"
  end

end

EM.run do
  1000.times do
    # EventMachine::connect '127.0.0.1', 3000, Client
    http = EventMachine::HttpRequest.new('http://localhost:3000/streams/test').get
    http.stream { |chunk| print chunk.size }
  end
end