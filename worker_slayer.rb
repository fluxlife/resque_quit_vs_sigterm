class WorkerSlayer
	def self.pid
		file = File.expand_path("../pids/worker.pid",__FILE__)
		File.read(file).to_i
	end
	
	def self.sigterm
		puts "I'm in a bad mood today...KILL THE WORKERS!!!"
		Process.kill("TERM",pid)
	end
	
	def self.quit
		puts "I'm in a good mood..just QUIT the workers today."
		Process.kill("QUIT",pid)
	end
end
