#!/usr/bin/ruby

require 'net/http'
require 'uri'

# This next line makes debugging threaded programs
# in Ruby plausible. Otherwise exceptions just make
# threads quietly disappear.
Thread.abort_on_exception = true
  
HOST = "localhost"
PORT = Process.uid + 5000

# TODO:
#  Extend your client0.rb to use a separate thread for each
#  request so that the requests can be made concurrently.

#uri = URI("http://www.uml.edu:80/")
#nn  = 29
#rsp = Net::HTTP.get(uri)
#puts "#{nn}: #{rsp.slice(0, 80)}"

class WebClient
  def initialize(host, port)
    @uri = URI("http://#{HOST}:#{PORT}/")
  end

  def make_requests
    threads = []

    5.times do |nn|
      threads << Thread.new do
        resp = Net::HTTP.get(@uri)
        puts "#{nn}: #{resp}"
      end
    end

    threads.each do |thr|
      thr.join
    end
  end
end

client = WebClient.new(HOST, PORT)
client.make_requests
