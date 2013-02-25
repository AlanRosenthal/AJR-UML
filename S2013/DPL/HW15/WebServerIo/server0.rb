#!/usr/bin/ruby

require 'socket'

# This next line makes debugging threaded programs
# in Ruby plausible. Otherwise exceptions just make
# threads quietly disappear.
Thread.abort_on_exception = true

HOST = "localhost"
PORT = Process.uid + 5000

class WebServer
  def initialize(host, port)
    @counter = 0
    @values  = []

    puts "Listening on #{host}:#{port}"
    @socket = TCPServer.open(host, port)
  end

  def read_req(client)
    req = client.readline
    
    loop do
      hdr = client.readline
      break unless hdr =~ /\w/
    end
  end

  def do_work
    vv = @counter
    @counter += 1
    sleep(1 + rand)
    @values << vv
    @values
  end

  def accept_reqs
    threads = []
    5.times do
      threads << Thread.new(@socket.accept) do |client|
        read_req(client)
        client.puts "HTTP/1.1 200 OK"
        client.puts "Content-Type: text/plain"
        client.puts
        result = do_work
        client.puts result.to_s
        client.close
      end
    end

    threads.each do |thr|
      thr.join
    end
  end
end

server = WebServer.new(HOST, PORT)
server.accept_reqs
