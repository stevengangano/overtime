@employee = Employee.create!(first_name:'John', 
					last_name:'Doe',
					email: 'johndoe@yahoo.com', 
					password:'change123', 
					password_confirmation: 'change123',
					phone: '6502708530')

AdminUser.create(email:'stevengangano@yahoo.com', 
				 password:'password', 
				 password_confirmation:'password', 
				 first_name:'Steven', 
				 last_name:'Gangano',
				 phone: '4156500527')


AuditLog.create!(user_id: @employee.id, status: 0, start_date: (Date.today - 10.days))
AuditLog.create!(user_id: @employee.id, status: 0, start_date: (Date.today - 17.days))
AuditLog.create!(user_id: @employee.id, status: 0, start_date: (Date.today - 24.days))

puts "3 audit logs hve been created"
50.times do |post|
  Post.create!(date: Date.today, 
  			   rationale: "#{post} rationale content",
   			   user_id: @employee.id, 
   			   overtime_request: 2.5)
end

# 50.times do |audit_log|
#   AuditLog.create!(user_id: @user.id, 
#   				   status: 0, 
#   				   start_date: (Date.today - 6.days)
#   				)
# end

puts "A hundred posts have been setup"

