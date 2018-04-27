require 'rails_helper'

RSpec.describe User, type: :model do
	describe "creation" do
		before do #runs before the it block
			@user = User.create(email: "test@test.com", password: "password", password_confirmation:"password", first_name: "John", last_name: "Doe")
		end

		it "can be created" do
			expect(@user).to be_valid
		end

		it "cannot be created without first_name, last_name" do
			@user.first_name = nil
			@user.last_name = nil
			expect(@user).to_not be_valid
		end
	end

	#Checks to see if a full_name method is created
	describe "custom name methods" do
		it 'has a full name method that combines first and last name' do
			expect(@user.full_name).to eq("DOE, JOHN")
		end
	end
end
