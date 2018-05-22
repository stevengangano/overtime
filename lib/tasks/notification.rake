namespace :notification do
  desc "Sends SMS notificatioin to employees asking them to log if they had overtime or not"
  task sms: :environment do
  	puts "I am a rake task"
  	#1. Schedule to run at Sunday at 5pm
  	#2. Iterate over all employees
  	#3. Skip Admin/Users
  	#4. Send a message that has instructions and a link to log time	
  	# User.all.each do |user|
  	# 	SmsTool.send_sms()
  	# end
  	# number: '555-555-3233'
  	# number: '5555553233'
  	#no spaces or dashes
  	#exactly 10 characters
  	#all characters have to be a number
  end

end
