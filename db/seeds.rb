user = User.create! :first_name => 'John', :last_name => 'Doe', :email => 'johndoe@yahoo.com', :password => 'change123', :password_confirmation => 'change123'

50.times do |post|
  Post.create!(
    date: Date.today, rationale: "#{post} rationale content",
    user_id: 1
  )
end

puts "A hundred posts have been setup"
