require 'rails_helper'

#Checks to see if "posts_path" exists
describe 'navigate' do
  describe 'index' do
    it 'can be reached successfully' do
      visit posts_path
      expect(page.status_code).to eq(200)
    end

    #Checks to see if there is content on the page called "Posts"
    it 'has a title of Posts' do
      visit posts_path
      expect(page).to have_content(/Posts/)
    end
  end

  #Create a new describe block for new path
  describe 'creation' do
    before do
      #This mimicks a user logging in
      user = User.create(email: "test@test.com", password: "password", password_confirmation:"password", first_name: "John", last_name: "Doe")
      login_as(user, :scope => :user)
      visit new_post_path
    end
    #Checks to see if "new_post_path" exists
    it 'has a new form that can be reached' do
      #visit new_post_path
      expect(page.status_code).to eq(200)
    end

    #Checks form to see if has a form with date and rationale
    #Fills in the info with today's date and 'some rationale'
    #Then it will click save
    #It will check to see if the form created content that says 'some ratioinale'
    it 'can be created from new form page' do
      #visit new_post_path

      fill_in 'post[date]', with: Date.today
      fill_in 'post[rationale]', with: "Some rationale"

      click_on "Save"

      expect(page).to have_content("Some rationale")
    end

    it 'will have a user associated with it' do
      fill_in 'post[date]', with: Date.today
      fill_in 'post[rationale]', with: "User_Association"

      click_on "Save"

      expect(User.last.posts.last.rationale).to eq("User_Association")
    end
  end

end
