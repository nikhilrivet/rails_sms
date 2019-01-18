require 'socket'
class TelnetConnectorController < ApplicationController
  def index
    # hostname = '95.179.214.39'
    # port = 8990
    # s = TCPSocket.open(hostname, port)
    # s.puts('jcliadmin')
    # s.puts('jclipwd')
    # line = s.gets
    # byebug
    # while line = s.gets     # Read lines from the socket
    #   puts line.chop       # And print with platform line terminator
    #
    # end
    pop = Net::Telnet::new("Host" => "95.179.214.39",
                                 "Timeout" => 10,
                                 "Port" => 8990,
                                 "Prompt" => /[$%#>] \z/n)
    pop.cmd("Username: " + "jcliadmin") { |c| print c }
    pop.cmd("pass " + "jclipwd") { |c| print c }
    pop.cmd("list") { |c| print c }
  end
end
