require 'socket'
require 'net/telnet'
class TelnetConnectorController < ApplicationController
  def index
=begin
    telnet = Telnet.new()
    telnet.tcp_open
    users = telnet.connect_open
    puts users
    telnet.tcp_close
=end
=begin
    hostname = '95.179.214.39'
    port = 8990
    s = TCPSocket.open(hostname, port)
    s.puts('jcliadmin')
    s.puts('jclipwd')
    s.puts('user -l')
    s.puts('quit')
    while line = s.gets     # Read lines from the socket
      puts line.chop       # And print with platform line terminator
    end
    s.close
=end
    pop = Net::Telnet::new("Host" => "95.179.214.39",
                                 "Timeout" => 50,
                                 "Port" => 8990,
                                 "Prompt" => /[$%#>] \z/n,
                                  "telnetmode" =>true)

    pop.cmd("jcliadmin\njclipwd\nuser -a") { |c| print c }
    pop.cmd("username foo") { |c| print c }
    pop.cmd("password bar") { |c| print c }
    pop.cmd("gid foogroup") { |c| print c }
    pop.cmd("uid foo") { |c| print c }
    pop.cmd("ok") { |c| print c }
    pop.close
  end
end
