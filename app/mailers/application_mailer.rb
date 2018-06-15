class ApplicationMailer < ActionMailer::Base
	def email manager
		@manager = manager
		mail(to: @manager.email, subject: 'Daily overtime request email')
	end
end
