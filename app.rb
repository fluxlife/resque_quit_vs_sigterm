require 'resque'
require 'optparse'
require_relative 'worker_class'
require_relative 'worker_slayer'

options = {}.tap do |option|
	OptionParser.new do |opts|
		opts.banner = "Usage: ruby app.rb [options]"
		
		opts.on("-e","--enqueue","Enqueue a Worker Job") do |e|
			option[:enqueue] = true
		end
		
		opts.on("-d N", Integer, "Delay N seconds before Quiting or Sigterming.") do |n|
			option[:delay] = n
		end
		
		opts.on("-s","--sigterm","Send a SIGTERM to Resque") do |s|
			option[:method] = :sigterm
		end
		
		opts.on("-r","--resque", "Start resque") do |r|
			option[:resque] = true
		end
		
		opts.on("-q","--quit","Send a QUIT signal to Resque") do |q|
			option[:method] = :quit
		end
		
	end.parse!
end
if options[:resque]
	exec 'QUEUES=proletariat rake resque:work PIDFILE=pids/worker.pid'
else
	options[:delay] ||= 0
	Resque.enqueue WorkerClass unless options[:enqueue].nil?
	sleep options[:delay] if options[:delay] > 0
	WorkerSlayer.send options[:method] unless options[:method].nil?
end
