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

Start the server and go to http://localhost:3000/admin

```shell
rails s
```

default username is **admin@example.com** and the default password is **password**

# Step 4 - Lets have some authentication

Remember the devise gem we added to the Gemfile? ok, its time to put it to some use:

```ruby
rails generate devise:install
```

Answer *no* to the question that pops up.

Add default route to rails:
- edit the **config/routes.rb** and add the following line `root :to => "intouch#index"`

### Update the app/views/layouts/application.html.erb

Devise uses flash messages to display errors or success messages, so we are going to need to add something into our main layout:

```html
   <p class="notice"><%= notice %></p>
   <p class="alert"><%= alert %></p>
```

### Copy the devise views to your workspace for further customization

```
rails g devise:views
```

### Add the the devise user model

```
rails generate devise User
```

Run the Migrations

```
rake db:migrate
```
### Try to run the app server

```
rails s
```

What did just happened?? An error?

This is how rails displays it errors, fancy eh?? 

Those are all the routes that we have in our app, on the first column the method that returns the url so that you don't have to hardcode it on your templates, second column is the HTTP verb, third one is the route url...Wait what is that? you have a box to test your url against your routes?? nice goodie hunh? 
By last you have the controller and action (method in the controller) that each route will map to.

So...given the error message, the url we are trying to access, the controller#action we pointing to, and the fact that actually we haven't added any controller it seems we need to add one...let's do that:

```
rails generate controller Intouch index
```

This line should generate a controller name IntouchController with an action index. I guess this solves our problem. Let''s try it:

```
rails s
```



# Step 5 - Lets design our entity model

# Step 6 - Lets add these to the admin

# Step 7 - Now that we are happy with all goodies, lets design the real app!

# Step 8 - Add an image to an user

# Step 9 - Integrate with facebook




