class JasminConnector

  def initialize()
    @telnet = Telnet.new()
    @server = @telnet.telnet_open
  end

  def add_smppccm(cid, host, port, username, password)
    @server.cmd("smppccm -a")
    @server.cmd("cid " + cid)
    @server.cmd("host " + host)
    @server.cmd("port " + port)
    @server.cmd("username " + username)
    @server.cmd("password " + password)
    @server.cmd("submit_throughput 110")
    result = @server.cmd("ok")
    @server.cmd("quit")
    @telnet.telnet_close(@server)
    status = result.split(/[\r\n]+/)
    return_value = status[1].include? "Successfully added connector"
    return return_value
  end

  def delete_smppccm(cid)
    result = @server.cmd("smppccm -r " + cid)
    @server.cmd("quit")
    @telnet.telnet_close(@server)
    status = result.split(/[\r\n]+/)
    return_value = status[1].include? "Successfully removed connector"
    return return_value
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
