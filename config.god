God.watch do |w|
	 w.name = "simple"
	 w.dir = "/home/joro/Projects/resque_test"
	 w.start = "QUEUES=proletariat,bourgeois rake resque:work RESQUE_WORKER=true PIDFILE=pids/communist.pid"
   # w.pid_file = File.join(RAILS_ROOT, "log/mongrel.#{port}.pid")
   # w.stop_signal = 'QUIT'
   w.stop_timeout = 20.seconds
end
