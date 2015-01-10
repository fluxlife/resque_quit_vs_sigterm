class WorkerClass
	@queue = :proletariat
	def self.perform
		puts "Starting"
		(1..15).each do
		  puts "...Working"
		  sleep 1
		end
		puts "Stopping"
	end
end
