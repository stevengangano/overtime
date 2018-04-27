#Checks to see if an index route for PostsController exists
Create test for PostsController => def index

1) Create spec/features/post_spec.rb

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
        #Checks to see if "new_post_path" exists
        it 'has a new form that can be reached' do
          visit new_post_path
          expect(page.status_code).to eq(200)
        end

        #Checks form to see if has a form with date and rationale
        #Fills in the info with today's date and 'some rationale'
        #Then it will click save
        #It will check to see if the form created content that says 'some ratioinale'
        it 'can be created from new form page' do
          visit new_post_path

          fill_in 'post[date]', with: Date.today
          fill_in 'post[rationale]', with: "Some rationale"

          click_on "Save"

          expect(page).to have_content("Some rationale")
        end
      end

    end

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

3) Create new.html.erb:

    <%= form_for @post do |f| %>
      <%= f.label :date %>
      <%= f.date_select :date, :order => [ :month, :day, :year ] %>


      <%= f.text_area :rationale %>
      <%= f.submit 'Save' %>
    <% end %>

4) Create show.html.erb:

  <%= @post.inspect %>

5) Type rspec => no failures


Including Warden in rails_helper.rb:

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'

#Add this => mimicks logging in with devise
include Warden::Test::Helpers
Warden.test_mode!

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
  config.before(:each) { DatabaseCleaner.strategy = :transaction }
  config.before(:each, :js => true) { DatabaseCleaner.strategy = :truncation }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end


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
