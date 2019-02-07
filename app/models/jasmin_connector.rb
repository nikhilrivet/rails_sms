class JasminConnector

  def initialize()
    @telnet = Telnet.new()
    @server = @telnet.telnet_open
  end

  def add_smppccm(cid, host, port, username, password)
    @server.cmd("smppccm -a")
    @server.cmd("cid " + cid) { |c| print c }
    @server.cmd("host " + host) { |c| print c }
    @server.cmd("port " + port) { |c| print c }
    @server.cmd("username " + username) { |c| print c }
    @server.cmd("password " + password) { |c| print c }
    @server.cmd("submit_throughput 110") { |c| print c }
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
