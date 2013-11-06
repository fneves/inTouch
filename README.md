# Step 0 - Install ruby 2.0 + rails

# Step 1 - Create the Rails App

rails new inTouch

# Step 2 - Gemfile + required dependencies for the workshop

Add required dependencies to Gemfile.

```ruby
gem 'devise'
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'haml-rails'
gem 'bootstrap-generators', '~> 3.0'
```

# Step 3 - Lets have an admin interface

```shell
rails generate active_admin:install
rake db:migrate
```

Start the server and go to [http://localhost:3000/admin]

```shell
rails s
```

default username is **admin@example.com** and the default password is **password**

# Step 4 - Lets have some authentication

# Step 5 - Lets design our entity model

# Step 6 - Lets add these to the admin

# Step 7 - Now that we are happy with all goodies, lets design the real app!

# Step 8 - Add an image to an user

# Step 9 - Integrate with facebook




