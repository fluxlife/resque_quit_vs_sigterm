Resque::Failure.tap do |rf|
  rf.each do |index, failed_job|
    # Docs at http://www.rubydoc.info/github/defunkt/resque/Resque/Failure#requeue-class_method
    # Say the commented method below should work, but doesnt on my end.
	# rf.requeue_and_remove(index) if failed_job["exception"] == "Resque::DirtyExit"
	if failed_job["exception"] == "Resque::DirtyExit"
	  rf.requeue(index)
	  rf.remove(index)
	end
  end
end

