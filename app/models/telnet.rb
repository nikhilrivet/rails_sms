require 'socket'
require 'net/telnet'
class Telnet

  def initialize()
    @hostname = ENV['SMS_HOST']
    @port = ENV['SMS_PORT']
  end

  def telnet_open
    server = Net::Telnet::new("Host" => @hostname,
                           "Timeout" => 50,
                           "Port" => @port,
                           "Prompt" => /[$%#>:] \z/n
    )

    server.cmd("jcliadmin")
    server.cmd("jclipwd")
    return server
  end

  def telnet_close(server)
    server.cmd("quit") { |c| print c }
    server.close
  end

end
