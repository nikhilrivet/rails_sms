class JasminUser

  def initialize()
    @telnet = Telnet.new()
    @server = @telnet.telnet_open
  end

  def add_user(username, uid, sms_count)
    @server.cmd("user -a")
    @server.cmd("username " + username) { |c| print c }
    @server.cmd("password bar") { |c| print c }
    @server.cmd("gid foogroup") { |c| print c }
    @server.cmd("uid " + uid) { |c| print c }
    @server.cmd("mt_messaging_cred quota sms_count " + sms_count) { |c| print c }
    @server.cmd("ok\nquit") { |c| print c }
    @telnet.telnet_close(@server)
  end

  def get_users
    users =@server.cmd("user -l")
    @telnet.telnet_close(@server)
    return users
  end

end
