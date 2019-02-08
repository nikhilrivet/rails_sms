class JasminUser

  def initialize()
    @telnet = Telnet.new()
    @server = @telnet.telnet_open
  end

  def add_user(username, uid, sms_count)
    @server.cmd("user -a")
    @server.cmd("username " + username)
    @server.cmd("password bar")
    @server.cmd("gid foogroup")
    @server.cmd("uid " + uid)
    @server.cmd("mt_messaging_cred quota sms_count " + sms_count)
    result = @server.cmd("ok")
    @server.cmd("quit")
    @telnet.telnet_close(@server)
    status = result.split(/[\r\n]+/)
    return_value = status[1].include? "Successfully added User"
    return return_value
  end

  def update_user(uid, sms_count)
    @server.cmd("user -u" + uid)
    @server.cmd("mt_messaging_cred quota sms_count " + sms_count)
    result = @server.cmd("ok")
    @server.cmd("quit")
    @telnet.telnet_close(@server)
    status = result.split(/[\r\n]+/)
    return_value = status[1].include? "Successfully updated User"
    return return_value
  end

  def delete_user(uid)
    result = @server.cmd("user -r " + uid)
    @server.cmd("quit")
    @telnet.telnet_close(@server)
    status = result.split(/[\r\n]+/)
    return_value = status[1].include? "Successfully removed User"
    return return_value
  end

  def get_users
    users =@server.cmd("user -l")
    @telnet.telnet_close(@server)
    return users
  end

end
