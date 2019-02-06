class Telnet

  def initialize()
    @hostname = '95.179.214.39'
    @port = 8990
  end

  def tcp_open
    @server = TCPSocket.open(@hostname, @port)
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

  def tcp_close
    @server.close
  end

  def connect_open
    @server.puts('jcliadmin')

    @server.puts('jclipwd')
    while line = @server.gets
      puts line.chop
    end
    @server.puts('user -l')
    while line = @server.gets
      puts line.chop
    end
    @server.puts('quit')
    while line = @server.gets
      puts line.chop
    end


    return "sdfsdf"
  end

  def get_users
    users = do_command('user -l')
    return users
  end

  def do_command(command)
    @server.puts(command)
    while line = @server.gets
      return line.chop
    end
    return true
  end
end
