require 'socket'
require 'net/telnet'
class Telnet

  def initialize()
    @hostname = '95.179.214.39'
    @port = 8990
  end

  def telnet_open
    @server = Net::Telnet::new("Host" => @hostname,
                           "Timeout" => 50,
                           "Port" => @port,
                           "Prompt" => /[$%#>:] \z/n
    )

    @server.cmd("jcliadmin")
    @server.cmd("jclipwd")
    #return @server
=begin
    @server.puts('jcliadmin')
    @server.puts('jclipwd')
    @server.puts('user -l')
    line = s.gets
    while line = s.gets     # Read lines from the socket
      puts line.chop       # And print with platform line terminator
    end
    s.close
    return "aa"
=end

  end

  def telnet_close
    @server.cmd("quit") { |c| print c }
    @server.close
  end

  def get_users
    telnet_open
    users =@server.cmd("user -l")
    telnet_close
    return users
  end

end
