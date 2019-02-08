class JasminFilter

  def initialize()
    @telnet = Telnet.new()
    @server = @telnet.telnet_open
  end

  def add_filter(fid, type, parameter)
    @server.cmd("filter -a"){ |c| print c }
    @server.cmd("type " + type) { |c| print c }
    case type
      when 'TransparentFilter'

      when 'ConnectorFilter'
        @server.cmd("cid " + parameter) { |c| print c }
      when 'UserFilter'
        @server.cmd("uid " + parameter) { |c| print c }
      when 'GroupFilter'
        @server.cmd("gid " + parameter) { |c| print c }
      when 'SourceAddrFilter'
        @server.cmd("source_addr " + parameter) { |c| print c }
      when 'DestinationAddrFilter'
        @server.cmd("destination_addr " + parameter) { |c| print c }
      when 'ShortMessageFilter'
        @server.cmd("short_message " + parameter) { |c| print c }
      when 'DateIntervalFilter'
        @server.cmd("dateInterval " + parameter) { |c| print c }
      when 'TimeIntervalFilter'
        @server.cmd("timeInterval " + parameter) { |c| print c }
      when 'TagFilter'
        @server.cmd("tag " + parameter) { |c| print c }
      when 'EvalPyFilter'
        @server.cmd("pyCode " + parameter)
    end
    @server.cmd("fid " + fid)
    result = @server.cmd("ok")
    @server.cmd("persist")
    @server.cmd("quit")
    @telnet.telnet_close(@server)
    status = result.split(/[\r\n]+/)
    return_value = status[1].include? "Successfully added Filter"
    return return_value
  end

  def delete_filter(fid)
    result = @server.cmd("filter -r " + fid)
    @server.cmd("persist")
    @server.cmd("quit")
    @telnet.telnet_close(@server)
    status = result.split(/[\r\n]+/)
    return_value = status[1].include? "Successfully removed Filter"
    return return_value
  end

end
