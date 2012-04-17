require "testengineer/version"

module TestEngineer
  def wait_for_socket(host='localhost', port=nil)
    return if port.nil?

    puts "Waiting for server at #{host}:#{port} to come online.."
    running = false
    while !running do
      sleep 0.2
      begin
        TCPSocket.new(host, port)
      rescue Errno::ECONNREFUSED => e
        next
      end
      running = true
    end
  end

  def stop_process(name)
    if $foreman.nil?
      puts "Foreman hasn't been started, whoops"
      return
    end
    procs = $foreman.send(:running_processes)
    procs.each do |pid, p|
      parts = p.name.split('.')
      unless parts.first.start_with? name
        next
      end
      p.kill 'SIGTERM'
      Timeout.timeout(5) do
        begin
          Process.waitpid(pid)
        rescue Errno::ECHILD
        end
      end
    end
    # If we don't set @terminating to false, then the eventual invocation of
    # #terminate_gracefully will return immediately
    $foreman.instance_variable_set(:@terminating, false)
  end

  def start_stack
    procfile = File.expand_path(Dir.pwd + '/Procfile')
    unless File.exists? procfile
      raise StandardError, 'Procfile does not exist!'
    end
    $foreman = Foreman::Engine.new(procfile, {})

    Thread.new do
      $foreman.start
    end
  end

  def stop_stack
    $foreman.send(:terminate_gracefully) unless $foreman.nil?
    $foreman = nil
  end
end
