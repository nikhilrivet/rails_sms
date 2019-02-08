class JasminRouter

  def initialize()
    @telnet = Telnet.new()
    @server = @telnet.telnet_open
  end

  def add_router(order, type, rate, connector, filter)
    @server.cmd("mtrouter -a")
    @server.cmd("type " + type)
    case type
      when 'DefaultRoute'
        @server.cmd("connector smppc(" + connector + ")")
      when 'StaticMTRoute'
        @server.cmd("filters " + filter)
        @server.cmd("connector smppc(" + connector + ")")
        @server.cmd("order " + order)
      when 'RandomRoundrobinMTRoute'
        @server.cmd("filters " + filter)
        @server.cmd("connectors smppc(" + connector + ")")
        @server.cmd("order " + order)
      when 'FailoverMTRoute'
        @server.cmd("filters " + filter)
        @server.cmd("connectors smppc(" + connector + ")")
        @server.cmd("order " + order)
    end

    @server.cmd("rate " + rate)
    result = @server.cmd("ok")
    @server.cmd("quit")
    @telnet.telnet_close(@server)
    status = result.split(/[\r\n]+/)
    return_value = status[1].include? "Successfully added MTRoute"
    return return_value
  end

  def delete_router(order)
    result = @server.cmd("mtrouter -r " + order)
    @server.cmd("quit")
    @telnet.telnet_close(@server)
    status = result.split(/[\r\n]+/)
    return_value = status[1].include? "Successfully removed MT Route"
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
