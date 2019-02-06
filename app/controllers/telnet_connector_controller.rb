require 'socket'
class TelnetConnectorController < ApplicationController
  def index
    jasmin_user = JasminUser.new()
    users = jasmin_user.get_users
    puts users
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
=begin
    pop = Net::Telnet::new("Host" => "95.179.214.39",
                                 "Timeout" => 50,
                                 "Port" => 8990,
                                 "Prompt" => /[$%#>:] \z/n)

    pop.cmd("jcliadmin") { |c| print c }
    pop.cmd("jclipwd") { |c| print c }
    pop.cmd("user -l") { |c| print c }
=end
=begin
    pop.cmd("jclipwd") { |c| print c }
    pop.cmd("user -l") { |c| print c }
=end
  end
end
