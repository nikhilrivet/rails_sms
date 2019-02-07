class JasminRouter

  def initialize()
    @telnet = Telnet.new()
    @server = @telnet.telnet_open
  end

  def add_router(order, type, rate, connector)
    @server.cmd("mtrouter -a")
    @server.cmd("type " + type) { |c| print c }
    @server.cmd("connector smppc(" + connector + ")") { |c| print c }
    @server.cmd("rate " + rate) { |c| print c }
    @server.cmd("ok") { |c| print c }
    @server.cmd("quit") { |c| print c }
    @telnet.telnet_close(@server)
  end

  def start_smppccm(cid)
    @server = @telnet.telnet_open
    @server.cmd("smppccm -1 " + cid)
    @server.cmd("quit") { |c| print c }
    @telnet.telnet_close(@server)
  end

  def get_users
    users =@server.cmd("user -l")
    @telnet.telnet_close(@server)
    return users
  end

end
