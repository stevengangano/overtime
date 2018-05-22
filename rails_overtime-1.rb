#Checks to see if an index route for PostsController exists
# Create test for PostsController => def index

# 1) Create spec/features/post_spec.rb

#     require 'rails_helper'

#     #Checks to see if "posts_path" exists
#     describe 'navigate' do
#       describe 'index' do
#         it 'can be reached successfully' do
#           visit posts_path
#           expect(page.status_code).to eq(200)
#         end

#         #Checks to see if there is content on the page called "Posts"
#         it 'has a title of Posts' do
#           visit posts_path
#           expect(page).to have_content(/Posts/)
#         end
#       end

#       #Create a new describe block for new path
#       describe 'creation' do
#         #Checks to see if "new_post_path" exists
#         it 'has a new form that can be reached' do
#           visit new_post_path
#           expect(page.status_code).to eq(200)
#         end

#         #Checks form to see if has a form with date and rationale
#         #Fills in the info with today's date and 'some rationale'
#         #Then it will click save
#         #It will check to see if the form created content that says 'some ratioinale'
#         it 'can be created from new form page' do
#           visit new_post_path

#           fill_in 'post[date]', with: Date.today
#           fill_in 'post[rationale]', with: "Some rationale"

#           click_on "Save"

#           expect(page).to have_content("Some rationale")
#         end
#       end

#     end

Setup: 

1) rails new _4.2.8 new overtime
2) Copy and paste Gemfile from ad-project in bitbucket removing add-ons
except for devise

Create: 
  1)routes.rb: root to: 'static#homepage'
  2)CONTROLLER: static_controller.rb, def homepage end
  3)views/static/hompeage.html.erb
  4) Type: rspec => should pass (green)


Installing devise

1) Install gem => gem 'devise', '~> 4.4', '>= 4.4.3'
2) rails generate devise:install
3) rails g devise:views
4) Go to config/environments/development.rb and add to bottom:

   config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
5) config/intializers/devise.rb:

   Change to: config.mailer_sender = 'stevengangano@yahoo.com'

6) rails g devise User first_name:string last_name:string type:string

    invoke  active_record
      create    db/migrate/20180423052248_devise_create_users.rb
      create    app/models/user.rb
      invoke    rspec
      create      spec/models/user_spec.rb
      insert    app/models/user.rb
      route  devise_for :users

7) rake db:migrate

Creating an Admin User

1) Create file in models/admin_user.rb
    #This is single table inheritance (STI)
    #If you type AdminUser.last.type => "AdminUser"
    #Why? Because we added a column "type" in User schema
    #Type allows AdminUser to be inherited from User
    #So now there are two types: AdminUser and User
  class AdminUser < User

  end

2) Using rails in sandbox mode => rails c --sandbox

   #Doesnt actually save to the database
   User.create!(email: "test@test.com", password:"password", password_confirmation: "password")

   #This can be used because it inherits from User Model
   AdminUser.create!(email: "admintest@test.com", password:"password", password_confirmation: "password")

3) If you type 'User.last', this will show because it inherits from User:
  
   #B/c this inherits from 
   #Can also use => AdminUser.last
   AdminUser.create!(email: "admintest@test.com", password:"password", password_confirmation: "password")



2) Create routes

  class PostsController < ApplicationController
    def index
    end

    def new
      #This renders the new form
      @post = Post.new
    end

    def create
      #:post = model name
      @post = Post.new(params.require(:post).permit(:date, :rationale))
      @post.save

      redirect_to @post
    end

    def show
      @post = Post.find(params[:id])
    end
  end

3) Create actions for index, new, create, show
   Create views for index, new and show

4) Create new.html.erb:

    <%= form_for @post do |f| %>
      <%= f.label :date %>
      <%= f.date_select :date, :order => [ :month, :day, :year ] %>


      <%= f.text_area :rationale %>
      <%= f.submit 'Save' %>
    <% end %>

# 4) Create show.html.erb:

#   <%= @post.inspect %>

# 5) Type rspec => no failures


# Including Warden in rails_helper.rb:

# ENV['RAILS_ENV'] ||= 'test'
# require File.expand_path('../../config/environment', __FILE__)

# abort("The Rails environment is running in production mode!") if Rails.env.production?
# require 'spec_helper'
# require 'rspec/rails'
# require 'capybara/rails'

# #Add this => mimicks logging in with devise
# include Warden::Test::Helpers
# Warden.test_mode!

# ActiveRecord::Migration.maintain_test_schema!

# RSpec.configure do |config|
#   config.fixture_path = "#{::Rails.root}/spec/fixtures"
#   config.use_transactional_fixtures = false
#   config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
#   config.before(:each) { DatabaseCleaner.strategy = :transaction }
#   config.before(:each, :js => true) { DatabaseCleaner.strategy = :truncation }
#   config.before(:each) { DatabaseCleaner.start }
#   config.after(:each) { DatabaseCleaner.clean }
#   config.infer_spec_type_from_file_location!
#   config.filter_rails_from_backtrace!
# end


Create associations with posts and users

1) rails g migration add_users_posts user:references => rake db:migrate

2) models/posts.rb:

class Post < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :date, :rationale
end

3) models/user.rb:

class User < ActiveRecord::Base
  has_many :posts
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :last_name
end

4) Create a post and inspect if there is a user_id

5) This forces users to login

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
end

Note: bundle exec will execute command regardless if there are version differences


Styling (Installing boostrap) => Go to layoutit.com

1) gem 'bootstrap-sass', '~> 3.3', '>= 3.3.6' => bundle
2) Type in terminal to change to .scss

   mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.scss

3) Add this to application.scss:

    @import "bootstrap-sprockets";
    @import "bootstrap";
    @import "posts.scss";

4) Add boostrap sprockets to javascripts/application.js in this order:

    //= require jquery
    //= require bootstrap-sprockets
    //= require jquery_ujs
    //= require turbolinks
    //= require_tree .

5) Create views/shared/nav.html.erb:

  <div class='logo'>
    <h1>Time Tracker</h1>
  </div>

  <ul class="custom-nav nav nav-tabs">
    <li class="active">
      <%= link_to "Home", root_path %>
    </li>
    <li>
      <%= link_to "Time Entries", posts_path %>
    </li>
    <li class="dropdown pull-right">
       <a href="#" data-toggle="dropdown" class="dropdown-toggle">Account<strong class="caret"></strong></a>
      <ul class="dropdown-menu">
        <li>
          <%= link_to "Edit Details", edit_user_registration_path %>
        </li>
        <li class="divider">
        </li>
        <li>
          <%= link_to "Logout", destroy_user_session_path, method: :delete %>
        </li>
      </ul>
    </li>
  </ul>

6) Modify body for layouts/application.html.erb:

  <div class="container">
  	<div class="row">
  		<div class="col-md-12">
  			<%= render 'shared/nav' %>
  			<%= yield %>
  		</div>
  	</div>
  </div>

Creating "active" on navbar

1) Go to helpers/applicaton.html.erb

    module ApplicationHelper
      def active?(path)
        "active" if current_page?(path)
      end
    end

2) Go to shared/views/nav.html.erb:

    <div class='logo'>
    	<h1>Time Tracker</h1>
    </div>

    <ul class="custom-nav nav nav-tabs">
      #ADDED THIS
    	<li class="<%= active?(root_path) %>">
    		<%= link_to "Home", root_path %>
    	</li>
      #ADDED THIS
    	<li class="<%= active?(posts_path) %>">
    		<%= link_to "Time Entries", posts_path %>
    	</li>
      <li class="<%= active?(new_post_path) %>">
        <%= link_to "Add new entry", new_post_path %>
      </li>
    	<li class="dropdown pull-right">
    		 <a href="#" data-toggle="dropdown" class="dropdown-toggle">Account<strong class="caret"></strong></a>
    		<ul class="dropdown-menu">
    			<li>
    				<%= link_to "Edit Details", edit_user_registration_path %>
    			</li>
    			<li class="divider">
    			</li>
    			<li>
    				<%= link_to "Logout", destroy_user_session_path, method: :delete %>
    			</li>
    		</ul>
    	</li>
    </ul>

3) Create table in views/posts/index.html.erb => using layoutit.# COMBAK:

    <h1>Posts</h1>

    <table class="table table-striped table-hover">
      <thead>
        <tr>
          <th>
            #
          </th>
          <th>
            Date
          </th>
          <th>
            User
          </th>
          <th>
            Rationale
          </th>
        </tr>
      </thead>
      <tbody>
        <% @posts.each do |post| %>
          <tr>
            <td>
              <%= post.id %>
            </td>
            <td>
              <%= post.date %>
            </td>
            <td>
              <%= post.user.first_name + '  ' + post.user.last_name%>
            </td>
            <td>
              #SHORTENS CONTENT SO IT DOES BREAK THE LOOK OF THE TABLE
              #SEE METHODS FOR TRUNCATE ON RUBYONRAILS.ORG
              <%= truncate(post.rationale) %>
            </td>
          </tr>
        <% end %>
      </tbody>
    </table>

4) Add user to seeds.rb

  user = User.create! :first_name => 'John', :last_name => 'Doe', :email => 'johndoe@yahoo.com', :password => 'change123', :password_confirmation => 'change123'

  50.times do |post|
    Post.create!(
      date: Date.today, rationale: "#{post} rationale content",
      user_id: 1
    )
  end

  puts "A hundred posts have been setup"

Creating a full_name method

1) Go to models/user.rb:

    def full_name
      last_name.upcase + ", " + first_name.upcase
    end

2) Go to posts/index.html.erb and change to:

  <%= post.user.full_name >


Creating Edit, Update action/button

1) Create button in posts/index.html.erb:

    <td id="<%= "edit_#{post.id}" %>">
      <%= link_to 'Edit', edit_post_path(post) %>
    </td>

2) Create edit action in post controller:

    def edit
      @post = Post.find(params[:id])
    end

3) Create form partial posts/_form.html.erb:

    <%= form_for @post do |f| %>
      <%= f.label :date %>
      <%= f.date_select :date, :order => [ :month, :day, :year ] %>


      <%= f.text_area :rationale %>
      <%= f.submit 'Save' %>
    <% end %>


3) Create edit form using partial:

  <%= render 'form' >

4) Create new form using partial:

  <%= render 'form' >

5) Create update action post controller:

    def update
      @post = Post.find(params[:id])
      if @post.update(post_params)
        redirect_to @post, notice: 'Your post was created successfully'
      else
        render :edit
      end
    end

6) Create delete link in posts/index.html.erb:

    <td>
      <%= link_to 'Delete', post_path(post), method: :delete, data: { confirm: 'Are you sure?'} %>
    </td>

7) Create destroy actions in posts_controller.rb:

    def destroy
      @post = Post.find(params[:id])
      @post.delete
      redirect_to posts_path notice: 'Your post was deleted successfully'
    end


Styling /posts/_form.html.erb:

<%= form_for @post, class: "form-horizontal" do |f| >

  #DISPLAYS ERRORS MESSAGES
  <% @post.errors.full_messages.each do |error| %>
    <li><%= error %></li>
  <% end %>

  <div class="form-group">
  	<%= f.label :date, class: "col-sm-2 control-label" %>
  	<%= f.date_field :date, class: "form-control" %>
  </div>

  <div class="form-group">
  	<%= f.label :rationale, class: "col-sm-2 control-label" %>
  	<%= f.text_area :rationale, class: "form-control" %>
  </div>

  <%= f.submit 'Save', class: 'btn btn-primary btn-block' %>

<% end %>

Styling devise sign_in form => view/devise/sessions/new.html.erb:

<h2>Log in</h2>

<div class="row">
  <div class="col-md-4">
    <%= form_for(resource, as: resource_name, url: session_path(resource_name), class: "form-horizontal") do |f| %>
      <div class="form-group">
        <%= f.label :email %><br />
        <%= f.email_field :email, autofocus: true, class: "form-control" %>
      </div>

      <div class="form-group">
        <%= f.label :password, class: "control-label" %><br />
        <%= f.password_field :password, autocomplete: "off", class: "form-control" %>
      </div>

      <% if devise_mapping.rememberable? -%>
        <div class="form-group">
          <%= f.check_box :remember_me %>
          <%= f.label :remember_me, class: "control-label" %>
        </div>
      <% end -%>

      <div class="form-group">
        <%= f.submit "Log in", class: 'btn btn-primary' %>
      </div>
    <% end %>

    <%= render "devise/shared/links" %>
  </div>
</div>

Disabling Register:

1) Remove from views/devise/shared/_links.html.erb:

<% if devise_mapping.registerable? && controller_name != 'registrations' %>
  <%= link_to "Sign up", new_registration_path(resource_name) %><br />
<% end >

2) Got shared/_nav.html.erb:

  Changed edit button to: link_to "TODO: ADMIN DASHBOARD", root_path

3) Change routes.rb:

  #Redirect to root_path
  devise_for :users, skip: [:registrations]

Implementing Admin Dashboard

1) Add Gems

gem "administrate", "~> 0.2.2"
gem 'bourbon'

2) rails generate administrate:install

#Created its own routes
route  namespace :admin do
resources :users
resources :posts
resources :admin_users

root to: "users#index"
end
#Created its own controller
create  app/controllers/admin/application_controller.rb
create  app/dashboards/user_dashboard.rb
create  app/controllers/admin/users_controller.rb
create  app/dashboards/post_dashboard.rb
create  app/controllers/admin/posts_controller.rb
create  app/dashboards/admin_user_dashboard.rb
create  app/controllers/admin/admin_users_controller.rb


3) Add burbon to application.css.scss:

  @import "bourbon";

Modifying admin/admin_users/new


4) Go to app/dashboards/admin_user_dashboard.rb

#Note: 
#This changes the form for /admin/admin_users/new
#This is the page to create a new admin

require "administrate/base_dashboard"

class AdminUserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    posts: Field::HasMany,
    id: Field::Number,
    email: Field::String,
    password: Field::String,
    sign_in_count: Field::Number,
    current_sign_in_at: Field::DateTime,
    last_sign_in_at: Field::DateTime,
    current_sign_in_ip: Field::String.with_options(searchable: false),
    last_sign_in_ip: Field::String.with_options(searchable: false),
    first_name: Field::String,
    last_name: Field::String,
    # avatar: Field::Text,
    # username: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    type: Field::String,
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :posts,
    :id,
    :email,
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :posts,
    :id,
    :email,
    :sign_in_count,
    :current_sign_in_at,
    :last_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_ip,
    :first_name,
    :last_name,
    # :avatar,
    # :username,
    :created_at,
    :updated_at,
    :type,
  ].freeze

  # Displays Form values here
  # http://localhost:3000/admin/admin_users/new
  FORM_ATTRIBUTES = [
    # :posts,
    :email,
    :password,
    :first_name,
    :last_name,
    # :avatar,
    # :username,
    :type,
  ].freeze
end

5) Go to app/dashboards/user_dashboard.rb

#Note:
#Form to create a new user
#Creates form at http://localhost:3000/admin/users/new

class UserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    posts: Field::HasMany.with_options(searchable: false),
    id: Field::Number.with_options(searchable: false),
    email: Field::String.with_options(searchable: true),
    password: Field::String.with_options(searchable: false),
    sign_in_count: Field::Number.with_options(searchable: false),
    current_sign_in_at: Field::DateTime.with_options(searchable: false),
    last_sign_in_at: Field::DateTime.with_options(searchable: false),
    current_sign_in_ip: Field::String.with_options(searchable: false),
    last_sign_in_ip: Field::String.with_options(searchable: false),
    first_name: Field::String.with_options(searchable: false),
    last_name: Field::String.with_options(searchable: false),
    # avatar: Field::Text,
    # username: Field::String,
    created_at: Field::DateTime.with_options(searchable: false),
    updated_at: Field::DateTime.with_options(searchable: false)
    type: Field::String
  }.freeze

  #Displays on /admin/users
  COLLECTION_ATTRIBUTES = [
    :posts,
    # :id,
    :email,
    :type #shows if user is an "AdminUser"
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :posts,
    # :id,
    :email,
    :sign_in_count,
    :current_sign_in_at,
    :last_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_ip,
    :first_name,
    :last_name,
    # :avatar,
    # :username,
    :created_at,
    :updated_at,
    :type,
  ].freeze

  #These show on the form
  FORM_ATTRIBUTES = [
    # :posts,
    :email,
    :password,
    :first_name,
    :last_name
    # :avatar,
    # :username,
    # :type,
  ].freeze
end

6) Type rails c => User.all

Shows if new user and admin was added to the database


****Making searchbar functional****


1) Go to app/dashboards/user_dashboard.rb

#http://localhost:3000/admin/users

#Note:
#Add "with_options(searchable: false)" to every field except
#email. Change email to "with_options(searchable: true)".
#Only allows email to be searched

class UserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    posts: Field::HasMany.with_options(searchable: false),
    id: Field::Number.with_options(searchable: false),
    email: Field::String.with_options(searchable: true),
    password: Field::String.with_options(searchable: false),
    sign_in_count: Field::Number.with_options(searchable: false),
    current_sign_in_at: Field::DateTime.with_options(searchable: false),
    last_sign_in_at: Field::DateTime.with_options(searchable: false),
    current_sign_in_ip: Field::String.with_options(searchable: false),
    last_sign_in_ip: Field::String.with_options(searchable: false),
    first_name: Field::String.with_options(searchable: false),
    last_name: Field::String.with_options(searchable: false),
    # avatar: Field::Text,
    # username: Field::String,
    created_at: Field::DateTime.with_options(searchable: false),
    updated_at: Field::DateTime.with_options(searchable: false),
    type: Field::String.with_options(searchable: false)
  }.freeze

  #Displays on /admin/users
  COLLECTION_ATTRIBUTES = [
    :posts,
    # :id,
    :email,
    :type #shows if user is an "AdminUser"
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :posts,
    # :id,
    :email,
    :sign_in_count,
    :current_sign_in_at,
    :last_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_ip,
    :first_name,
    :last_name,
    # :avatar,
    # :username,
    :created_at,
    :updated_at,
    :type,
  ].freeze

  #These show on the form
  FORM_ATTRIBUTES = [
    # :posts,
    :email,
    :password,
    :first_name,
    :last_name
    # :avatar,
    # :username,
    # :type,
  ].freeze
end


2) Go to app/dashboards/post_dashboard.rb

#http://localhost:3000/admin/posts
#Note: Only allows rationale to be searched

require "administrate/base_dashboard"

class PostDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo.with_options(searchable: false),
    id: Field::Number.with_options(searchable: false),
    date: Field::DateTime.with_options(searchable: false),
    rationale: Field::String.with_options(searchable: true),
    text: Field::String.with_options(searchable: false),
    created_at: Field::DateTime.with_options(searchable: false),
    updated_at: Field::DateTime.with_options(searchable: false)
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :id,
    :date,
    :rationale,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :id,
    :date,
    :rationale,
    :text,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :date,
    :rationale,
    :text,
  ].freeze

  # Overwrite this method to customize how posts are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(post)
  #   "Post ##{post.id}"
  # end
end


3) Go to app/dashboards/admin_user_dashboard.rb

#http://localhost:3000/admin/admin_users
#Note: Only allow email to be searched

class AdminUserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    posts: Field::HasMany.with_options(searchable: false),
    id: Field::Number.with_options(searchable: false),
    email: Field::String.with_options(searchable: true),
    password: Field::String.with_options(searchable: false),
    sign_in_count: Field::Number.with_options(searchable: false),
    current_sign_in_at: Field::DateTime.with_options(searchable: false),
    last_sign_in_at: Field::DateTime.with_options(searchable: false),
    current_sign_in_ip: Field::String.with_options(searchable: false),
    last_sign_in_ip: Field::String.with_options(searchable: false),
    first_name: Field::String.with_options(searchable: false),
    last_name: Field::String.with_options(searchable: false),
    # avatar: Field::Text,
    # username: Field::String,
    created_at: Field::DateTime.with_options(searchable: false),
    updated_at: Field::DateTime.with_options(searchable: false),
    type: Field::String.with_options(searchable: false)
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :posts,
    :id,
    :email,
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :posts,
    :id,
    :email,
    :sign_in_count,
    :current_sign_in_at,
    :last_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_ip,
    :first_name,
    :last_name,
    # :avatar,
    # :username,
    :created_at,
    :updated_at,
    :type,
  ].freeze

  FORM_ATTRIBUTES = [
    # :posts,
    :email,
    :password,
    :first_name,
    :last_name,
    # :avatar,
    # :username,
    :type,
  ].freeze
end


****Only allowing admin user to access admin dashboard****

1) Go to controllers/admin/application_controller:

module Admin
  class ApplicationController < Administrate::ApplicationController
    #Ensure user must be logged in to access dashboard
    before_action :authenticate_user!
    before_filter :authenticate_admin

    #Only if user of type "AdminUser" allow access to "/admin"
    def authenticate_admin
      unless current_user.try(:type) == "AdminUser"
        flash[:alert] = "You are not authorized to access this page."
        redirect_to(root_path)
      end
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end

****Building the approval workflow****


1) Create a status for a post

rails g migration add_status_to_posts status:integer

2) Go to migration and default:0:

class AddStatusToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :status, :integer, default: 0
  end
end

3) rake db:migrate

4) Go models/post.rb:

class Post < ActiveRecord::Base
  enum status: { submitted: 0, approved: 1, rejected:2 }
  belongs_to :user
  validates_presence_of :date, :rationale
end

5) Add "status" to  attribute_types, collection_attributes, and show_page_attributes:

require "administrate/base_dashboard"

class PostDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo.with_options(searchable: false),
    id: Field::Number.with_options(searchable: false),
    date: Field::DateTime.with_options(searchable: false),
    rationale: Field::String.with_options(searchable: true),
    text: Field::String.with_options(searchable: false),
    created_at: Field::DateTime.with_options(searchable: false),
    updated_at: Field::DateTime.with_options(searchable: false),
    status: Field::Text.with_options(searchable: false)
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :id,
    :date,
    :rationale,
    :status
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :id,
    :date,
    :rationale,
    :text,
    :created_at,
    :updated_at,
    :status
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :date,
    :rationale,
    :text
  ].freeze

  # Overwrite this method to customize how posts are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(post)
  #   "Post ##{post.id}"
  # end
end


6) Add radio buttons to _form.html.erb:

<%= form_for @post, class: "form-horizontal" do |f| %>

  <% @post.errors.full_messages.each do |error| %>
    <li><%= error %></li>
  <% end %>

  <div class="form-group">
    <%= f.label :date, class: "col-sm-2 control-label" %>
    <%= f.date_field :date, class: "form-control" %>
  </div>

  <div class="form-group">
    <%= f.label :rationale, class: "col-sm-2 control-label" %>
    <%= f.text_area :rationale, class: "form-control" %>
  </div>

  <div class="form-group">
    <%= f.radio_button :status, 'submitted' %>
    <%= f.label :status, 'Submitted' %>

    <br>
    
    <%= f.radio_button :status, 'approved' %>
    <%= f.label :status, 'Approved' %>

    <br>

    <%= f.radio_button :status, 'rejected' %>
     <%= f.label :status, 'Rejected' %>         
  </div>

  <%= f.submit 'Save', class: 'btn btn-primary btn-block' %>

<% end %>

****Hiding approval radio buttons from non-admins*****

1) Create partial for radio buttons (views/posts/_status.html.erb):

  <div class="form-group">
    <%= f.radio_button :status, 'submitted' %>
    <%= f.label :status, 'Submitted' %>

    <br>
    
    <%= f.radio_button :status, 'approved' %>
    <%= f.label :status, 'Approved' %>

    <br>

    <%= f.radio_button :status, 'rejected' %>
     <%= f.label :status, 'Rejected' %>         
  </div>

2) Insert partial into (_form.html.erb):

<%= form_for @post, class: "form-horizontal" do |f| %>

  <% @post.errors.full_messages.each do |error| %>
    <li><%= error %></li>
  <% end %>

  <div class="form-group">
    <%= f.label :date, class: "col-sm-2 control-label" %>
    <%= f.date_field :date, class: "form-control" %>
  </div>

  <div class="form-group">
    <%= f.label :rationale, class: "col-sm-2 control-label" %>
    <%= f.text_area :rationale, class: "form-control" %>
  </div>

  #ADD THIS!!!!!
  <%= render partial:'status', locals: { f: f } if current_user.type == 'AdminUser' %>

  <%= f.submit 'Save', class: 'btn btn-primary btn-block' %>

<% end %>

3) Fix navbar so that it only allows admin to access admin dashboard:


<div class='logo'>
  <h1>Time Tracker</h1>
</div>

<% if current_user %>
<ul class="custom-nav nav nav-tabs">
  <li class="<%= active?(root_path) %>">
    <%= link_to "Home", root_path %>
  </li>
  <li class="<%= active?(posts_path) %>">
    <%= link_to "Time Entries", posts_path %>
  </li>
  <li class="<%= active?(new_post_path) %>">
    <%= link_to "Add new entry", new_post_path %>
  </li>
  <li class="dropdown pull-right">
     <a href="#" data-toggle="dropdown" class="dropdown-toggle">Options<strong class="caret"></strong></a>
    <ul class="dropdown-menu">

    #Add here
      <% if current_user.type == "AdminUser" %>
      <li>
        <%= link_to "ADMIN DASHBOARD", admin_root_path %>
      </li>
      <li class="divider">
      <% end %>
      </li>
      <li>
        <%= link_to "Logout", destroy_user_session_path, method: :delete %>
      </li>
    </ul>
  </li>
</ul>
<% end >

# Using pundit to allow authorization for users and admins to edit post
1)

Install Pundit

gem 'pundit', '~> 1.1'

2) Type: rails g pundit:install

 create  app/policies/application_policy.rb

3) Create a policy

class PostPolicy < ApplicationPolicy
  #Update only if creator or AdminUser
  def update?
    #record = post
    #record.user_id = post.user_id
    record.user_id == user.id || user.type == 'AdminUser'
  end
end

4) "include Pundit" in application controller

class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
end


5) Add authorization to posts_controller.rb in edit and update actions:

  # This only allows post creator or admin user to edit and update

class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]

  def index
    @posts = Post.all
  end

  def new
    #This renders the new form
    @post = Post.new
  end

  def create
    #:post = model name
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      redirect_to @post, notice: 'Your post was created successfully'
    else
      render :new
    end
  end

  def edit
    #ADD THIS
    authorize @post
  end

  def update
    #ADD THIS
    authorize @post
    if @post.update(post_params)
      redirect_to @post, notice: 'Your post was created successfully'
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.delete
    redirect_to posts_path notice: 'Your post was deleted successfully'
  end

  def show
    # @post = Post.find(params[:id])
  end

  private
  def post_params
    params.require(:post).permit(:date, :rationale, :status)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end

6) Allowing only user to edit their own post and allowing
   admin to edit all. Go application_controller.rb:

 class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    redirect_to root_path
  end 
end

1) Index page should only show the current users posts:

class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]

  #ADD THIS HERE
  def index
    @posts = current_user.posts
  end
  #*************

end


1) Once an admin approves a post, user should not be able to edit it:

class PostPolicy < ApplicationPolicy
  #This only allows creator to edit their own post
  def update?
    #Update post if admin is logged in and post is approved
    return true if admin? && post_approved?
    #Update post if post creator or admin and post is not approved
    return true if user_or_admin && !post_approved?
  end

  private

  #Post creator is equal to current user or admin
  def user_or_admin
    record.user.id == user.id || admin?
  end

  #Admin type is AdminUser
  def admin?
    user.type == 'AdminUser'
  end

  #Admin submitted timecard as approved
  def post_approved?
    record.approved?
  end
end

2) Add status column to "/posts":

Add this to views/posts/index.html.erb:

<h1>Posts</h1>

<table class="table table-striped table-hover">
  <thead>
    <tr>
      <th>
        #
      </th>
      <th>
        Date
      </th>
      <th>
        User
      </th>
      <th>
        Rationale
      </th>
      #ADDED THIS
      <th>
        Status
      </th>     
    </tr>
  </thead>
  <tbody>
    <% @posts.each do |post| %>
      <tr>
        <td>
          <%= post.id %>
        </td>
        <td>
          <%= post.date %>
        </td>
        <td>
          <%= post.user.full_name%>
        </td>
        <td>
          <%= truncate(post.rationale) %>
        </td>
        #ADDED THIS
        <td>
          <%= status_label post.status %>
        </td>
        <td>
          <%= link_to 'Edit', edit_post_path(post), id: "edit_${post.id}" %>
        </td>
        <td>
          <%= link_to 'Delete', post_path(post), method: :delete, data: { confirm: 'Are you sure?'} %>
        </td>
      </tr>
    <% end %>
  </tbody>
</table>


3) Color coding status on "/posts":


Step 1:

Go to helpers/posts_helper.rb:

module PostsHelper
  #'status' is the value we are wrapping the span in
  def status_label status
    case status
      #:span is html tag, 'status' is the value the span will be wrapped in aka post.status,
      #class: 'label label-primary' is the color
      #titleize is used to make it capital
    when 'submitted'
      content_tag(:span, status.titleize, class: 'label label-primary')
    when 'approved'
      content_tag(:span, status.titleize, class: 'label label-success')
    when 'rejected'
      content_tag(:span, status.titleize, class: 'label label-danger')
    end
  end
end

Step 2:

Go to views/posts/index.html.erb:

  <tbody>
    <% @posts.each do |post| %>
      <tr>
        <td>
          <%= post.id %>
        </td>
        <td>
          <%= post.date %>
        </td>
        <td>
          <%= post.user.full_name%>
        </td>
        <td>
          <%= truncate(post.rationale) %>
        </td>
        #ADD THIS
        <td>
          <%= status_label post.status %>
        </td>
        <td>
          <%= link_to 'Edit', edit_post_path(post), id: "edit_${post.id}" %>
        </td>
        <td>
          <%= link_to 'Delete', post_path(post), method: :delete, data: { confirm: 'Are you sure?'} %>
        </td>
      </tr>
    <% end %>
  </tbody>


4) Hiding edit if status is rejected or approved:

  <tbody>
    <% @posts.each do |post| %>
      <tr>
        <td>
          <%= post.id %>
        </td>
        <td>
          <%= post.date %>
        </td>
        <td>
          <%= post.user.full_name%>
        </td>
        <td>
          <%= truncate(post.rationale) %>
        </td>
        <td>
          <%= status_label post.status %>
        </td>
        #ADD THIS
        <td>
          <%= link_to 'Edit', edit_post_path(post) if post.status != 'approved' %>
        </td>
        <td>
          <%= link_to 'Delete', post_path(post), method: :delete, data: { confirm: 'Are you sure?'} %>
        </td>
      </tr>
    <% end %>
  </tbody>

Installing PUMA - makes web server faster:

1) gem 'puma', '~> 3.11', '>= 3.11.4'

2) Type: rails s Puma


Adding overtime hours to Post:

1) rails g migration add_post_hour_request_to_posts overtime_request:decimal


2) Add default:

class AddPostHourRequestToPosts < ActiveRecord::Migration
  def change
    #The default value for overtime_request is 0.0
    add_column :posts, :overtime_request, :decimal, default: 0.0
  end
end

3) rake db:migrate

Add to models/post.rb:

class Post < ActiveRecord::Base
  enum status: { submitted: 0, approved: 1, rejected:2 }
  belongs_to :user
  #This says a value must be entered here
  validates_presence_of :date, :rationale, :overtime_request
  #This says the value entered must be greater than 0.0
  validates :overtime_request, numericality: { greater_than: 0.0}
end


4) Add overtime request form in _forms.html.erb:

 <div class="form-group">
    <%= f.label :overtime_request, class: "col-sm-2 control-label" %>
    <%= f.text_field :overtime_request, class: "form-control" %>
  </div>


5) Add ':overtime' to params:

  private

  def post_params
    params.require(:post).permit(:date, :rationale, :status, :overtime_request)
  end


Fixing showing page:

1) Create a link to show page:

<h1>Posts</h1>

<table class="table table-striped table-hover">
  <thead>
    <tr>
      <th>
        #
      </th>
      <th>
        Date
      </th>
      <th>
        User
      </th>
      <th>
        Rationale
      </th>
      <th>
        Status
      </th>     
    </tr>
  </thead>
  <tbody>
    <% @posts.each do |post| %>
      <tr>
        <td>
          <%= post.id %>
        </td>
        <td>
          <%= post.date %>
        </td>
        <td>
          <%= post.user.full_name%>
        </td>
        #ADD THIS
        <td>
          <%=link_to truncate(post.rationale), post_path(post) %>
        </td>
        <td>
          <%= status_label post.status %>
        </td>
        <td>
          <%= link_to 'Edit', edit_post_path(post) if post.status != 'approved' %>
        </td>
        <td>
          <%= link_to 'Delete', post_path(post), method: :delete, data: { confirm: 'Are you sure?'} %>
        </td>
      </tr>
    <% end %>
  </tbody>
</table>


2) Go to show.html.erb:

<%= @post.inspect %>

<div class="well">
  <div>
    <h2><span> Rationale:</span> <%= @post.rationale %> </h2>
  </div>

  <div>
    <h3> <span> Overtime Amount Request: </span> <%= @post.overtime_request %> </h3>
  </div>

  <div>
    <h3><span> Date: </span><%= @post.date %> </h3>
  </div>

  <div>
    <h3> <span> Employee:  </span> <%= @post.user.first_name + ' ' + @post.user.last_name %> </h3>
  </div>
</div>

<td>
  <%= link_to 'Edit', edit_post_path(@post) if @post.status != 'approved' %>
</td>


Installing Twilio:

1) gem 'twilio-ruby', '~> 5.10'

2) gem 'dotenv-rails', :groups => [:development, :test]

3) Create .env file and add:

TWILIO_ACCOUNT_SID=YOURACCOUNTSID
TWILIO_AUTH_TOKEN=YOURAUTHTOKEN
TWILIO_PHONE_NUMBER=+16502708530

4) Go twilio.com and create account:

Retrieve twilio account sid, auth token and phone number from website.

5) Go application.rb:

require File.expand_path('../boot', __FILE__)

require 'rails/all'

module Overtime
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
    #ADD THIS
    config.autoload_paths << Rails.root.join("lib")
  end
end

6) Create a file called in lib/sms_tool.rb:

module SmsTool
  def self.send_sms(number: number, message: message)
      puts "sending sms....."
      puts "#{message} to #{number}"
  end
end


7) Create a custom rake file:

rails g task notification sms

create  lib/tasks/notification.rake


8) Go to lib/tasks/notification.rake:

namespace :notification do
  desc "TODO"
  task sms: :environment do
  end

end

9) Type: rake -T

This should show:

rake notification:sms  # Sends SMS notificatioin to emplo...                  # Sends SMS notificatioin to emplo...

10) Create a migration file to add phone number to user:


rails g migration add_phone_to_users phone:string


11) Go to seeds file and add phone for username and admin:

user = User.create! :first_name => 'John', :last_name => 'Doe', :email => 'johndoe@yahoo.com', :password => 'change123', :password_confirmation => 'change123', :phone => '4156500527'

AdminUser.create(email:'stevengangano@yahoo.com', 
         password:'password', 
         password_confirmation:'password', 
         :'Steven', 
         last_name:'Gangano',
         phone: '4156500527')

50.times do |post|
  Post.create!(
    date: Date.today, rationale: "#{post} rationale content",
    user_id: 1, overtime_request: 2.5
  )
end

puts "A hundred posts have been setup"

12) Go to dashboards/user.dashboard.rb:

Add phone to:

require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    posts: Field::HasMany.with_options(searchable: false),
    id: Field::Number.with_options(searchable: false),
    email: Field::String.with_options(searchable: true),
    password: Field::String.with_options(searchable: false),
    sign_in_count: Field::Number.with_options(searchable: false),
    current_sign_in_at: Field::DateTime.with_options(searchable: false),
    last_sign_in_at: Field::DateTime.with_options(searchable: false),
    current_sign_in_ip: Field::String.with_options(searchable: false),
    last_sign_in_ip: Field::String.with_options(searchable: false),
    first_name: Field::String.with_options(searchable: false),
    last_name: Field::String.with_options(searchable: false),
    # avatar: Field::Text,
    # username: Field::String,
    created_at: Field::DateTime.with_options(searchable: false),
    updated_at: Field::DateTime.with_options(searchable: false),
    type: Field::String.with_options(searchable: false),
    #Add this
    phone: Field::String.with_options(searchable: false),
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :posts,
    # :id,
    :email,
    :type
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :posts,
    # :id,
    :email,
    :sign_in_count,
    :current_sign_in_at,
    :last_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_ip,
    :first_name,
    :last_name,
    #Add this
    :phone,
    # :avatar,
    # :username,
    :created_at,
    :updated_at,
    :type,
  ].freeze

  FORM_ATTRIBUTES = [
    # :posts,
    :email,
    :password,
    :first_name,
    :last_name,
    #Add this
    :phone
    # :avatar,
    # :username,
    # :type,
  ].freeze
end

13) Go to dashboards/admin_user_dashboard.rb:

require "administrate/base_dashboard"

class AdminUserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    posts: Field::HasMany.with_options(searchable: false),
    id: Field::Number.with_options(searchable: false),
    email: Field::String.with_options(searchable: true),
    password: Field::String.with_options(searchable: false),
    sign_in_count: Field::Number.with_options(searchable: false),
    current_sign_in_at: Field::DateTime.with_options(searchable: false),
    last_sign_in_at: Field::DateTime.with_options(searchable: false),
    current_sign_in_ip: Field::String.with_options(searchable: false),
    last_sign_in_ip: Field::String.with_options(searchable: false),
    first_name: Field::String.with_options(searchable: false),
    last_name: Field::String.with_options(searchable: false),
    # avatar: Field::Text,
    # username: Field::String,
    created_at: Field::DateTime.with_options(searchable: false),
    updated_at: Field::DateTime.with_options(searchable: false),
    type: Field::String.with_options(searchable: false),
    #ADD THIS
    phone: Field::String.with_options(searchable: false),
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :posts,
    :id,
    :email,
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :posts,
    :id,
    :email,
    #ADD THIS
    :phone,
    :sign_in_count,
    :current_sign_in_at,
    :last_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_ip,
    :first_name,
    :last_name,
    # :avatar,
    # :username,
    :created_at,
    :updated_at,
    :type,
  ].freeze

  FORM_ATTRIBUTES = [
    # :posts,
    :email,
    #ADD THIS
    :phone,
    :password,
    :first_name,
    :last_name,
    # :avatar,
    # :username,
    :type,
  ].freeze
end


7) Create a regular expression in User model:

#The regular expression allows that a 10 digit number to be created without spaces

class User < ActiveRecord::Base
  has_many :posts
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :last_name, :phone

  PHONE_REGEX = /\A[0-9]*\Z/

  validates_format_of :phone, with: PHONE_REGEX

  validates :phone, length: { is: 10 }
  
  def full_name
    last_name.upcase + ", " + first_name.upcase
  end

end


8) Go to lib/sms_tool.rb:

module SmsTool
  account_sid = ENV['TWILIO_ACCOUNT_SID']
  auth_token = ENV['TWILIO_AUTH_TOKEN']

  @client = Twilio::REST::Client.new account_sid, auth_token

  def self.send_sms(number:, message:)
    @client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: "+1#{number}",
      body: "#{message}"
    )
  end
end


9) Go rails console and type:

  6502708530 => Needs to be a verified number on twilio account

  SmsTool.send_sms(number: '6502708530', message:"are you trying to session today?")



Creating an audit log: To keep track if an employee had overtime or not

1) rails g resource AuditLog user:references status:integer start_date:date end_date:date


2) Add default: 0 to status:

class CreateAuditLogs < ActiveRecord::Migration
  def change
    create_table :audit_logs do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :status, default: 0
      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end
  end
end

3) Go to models/user.rb:

class User < ActiveRecord::Base
  has_many :posts
  #ADD THIS
  has_many :audit_logs
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :last_name, :phone

  PHONE_REGEX = /\A[0-9]*\Z/

  validates_format_of :phone, with: PHONE_REGEX

  validates :phone, length: { is: 10 }

  def full_name
    last_name.upcase + ", " + first_name.upcase
  end

end


4) Go to models/audit_log.rb:

class AuditLog < ActiveRecord::Base
  #ADD THIS
  belongs_to :user
end

5) Add AuditLog to seeds.rb:

user = User.create!(first_name:'John', 
          last_name:'Doe',
          email: 'johndoe@yahoo.com', 
          password:'change123', 
          password_confirmation: 'change123',
          phone: '4156500527')

AdminUser.create(email:'stevengangano@yahoo.com', 
         password:'password', 
         password_confirmation:'password', 
         first_name:'Steven', 
         last_name:'Gangano',
         phone: '4156500527')

50.times do |post|
  Post.create!(date: Date.today, 
           rationale: "#{post} rationale content",
           user_id: 1, 
           overtime_request: 2.5)
end

#ADD THIS
50.times do |audit_log|
  AuditLog.create!(user_id: @user.id, 
             status: 0,
             #GO BACK 6 DAYS FROM TODAY'S DATE 
             start_date: (Date.today - 6.days)
          )
end

puts "A hundred posts have been setup"



5) Add validations and set a default of start 
   in models/auditlog.rb:


class AuditLog < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :status, :start_date

  #This shows if start_date is nil
  after_initialize :set_defaults

  private

  #Use self if your not talking about the whole attribute as a whole
  def set_defaults
    self.start_date ||= Date.today - 6.days
  end

end


6) Create tab for Audit Log on navbar:

  <li class="<%= active?(posts_path) %>">
    <%= link_to "Audit Log", posts_path %>
  </li>


7) Hide Audit Log tab on navbar by creating a policy:

   Create policies/audit_log.policy.rb:

  class AuditLogPolicy < ApplicationPolicy
    #Override index action for Audit Log 
    def index?
      #Show Audit Log only if admin
      return true if admin?

    private
    #Admin type is AdminUser
    def admin?
      user.type == 'AdminUser'
    end

  end

8) Show in navbar if only admin:

  <% if policy(AuditLog).index? >
  <li class="<%= active?(posts_path) %>">
    <%= link_to "Audit Log", posts_path %>
  </li>
  <% end >


Building the auditlog index page

1) Go routes.rb:

  resources :audit_logs, except: [:new, :edit, :destroy]

2) Add index action to audit_logs_controller.rb:

   class AuditLogsController < ApplicationController
    def index
      @audit_logs = AuditLog.all
    end
   end


3) Create views/audit_logs/index.html.erb:

    <% @audit_logs.each do |al| %>
      <%= al.user.inspect %> <br>
    <% end >


4) Block non-admin users from accessing index page for audit logs:


  class AuditLogsController < ApplicationController
    def index
      @audit_logs = AuditLog.all
      authorize @audit_logs
    end
  end


5) Styling AuditLog index page:

<table class="table table-striped table-hover">
  <thead>
    <tr>
      <th>
        #
      </th>
      <th>
        Employee
      </th>
      <th>
        Week Starting
      </th>
      <th>
        Confirmed At
      </th>
      <th>
        Status
      </th>     
    </tr>
  </thead>
  <tbody>
    <% @audit_logs.each do |al| %>
    <tr>
      <td><%= al.id %></td>
      <td><%= al.user.full_name %></td>
      <td><%= al.start_date %></td>
      <td><%= al.end_date %></td>
      <td><%= al.status %></td>
    </tr>
    <% end %>
  </tbody>
</table>


6) Create an enum for 'status'. Go to models/audit_log.rb:





















Installing Factory Girl for testing

1) Go to gemfile and add factory_girl:

  group :development, :test do
    gem 'factory_girl_rails', '~> 4.5'
  end

2) Go to spec/rails_helper.rb and add to very bottom:

  config.include FactoryGirl::Syntax::Methods

3) Create spec/factories/posts.rb: (Note: posts is plural b/c of model)

    FactoryGirl.define do
      factory :post do
        date Date.today
        rationale "Some rationale"
      end

      factory :admint, class: "Post" do
        date Date.yesterday
        rationale "Some rationale"
      end
    end

4) Create spec/factories/users.rb: (Note: users is plural b/c of model):

    FactoryGirl.define do
      factory :user do
        first_name 'John'
        last_name 'Doe'
        email: "johndoe@yahoo.com"
        password "change123"
        password_confirmation "change123"
      end

      #class is AdminUser from User Model Inheritance, schema 'type'
      factory :admin_user, class: "AdminUser" do
        first_name 'Admin'
        last_name 'User'
        email: "janedoe@yahoo.com"
        password "change123"
        password_confirmation "change123"
      end
    end

5) To test go to: rails c -e test

6) Run test record for :user:

   FactoryGirl.create(:user)
