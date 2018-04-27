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
