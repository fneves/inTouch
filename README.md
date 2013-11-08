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

Start the server and go to [http://localhost:3000/admin](http://localhost:3000/admin)

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

Those are all the routes that we have in our app.
- on the first column the method that returns the url so that you don't have to hardcode it on your templates
- second column is the HTTP verb
- third one is the route url...Wait what is that? you have a box to test your url against your routes?? nice goodie hunh? 
- By last you have the controller and action (method in the controller) that each route will map to.

So...given the error message, the url we are trying to access, the controller#action we pointing to, and the fact that actually we haven't added any controller it seems we need to add one...let's do that:

```
rails generate controller Intouch index
```

This line should generate a controller name IntouchController with an action index. I guess this solves our problem. Let''s try it:

```
rails s
```

###Make authentication work

Lets require authentication in our inTouch controller urls.

Edit your **app/controllers/intouch_controller.rb** and add `before_filter :authenticate_user!` line right after the class definition, so that your class looks like this:
```ruby
class IntouchController &lt; ApplicationController
  before_filter :authenticate_user!

  ...
```
Refresh the page on your browser.

Great!!! It works. Go on to admin mode to check the if the user you've just created really exists on the database!

###Ooops...there is nothing there!!

Don't worry, it is easy to solve..you just need to tell active_admin that you want it to manage the **Users** table

```
rails generate active_admin:resource User
```

Go back to admin... and yes... there it is... 

# Step 5 - Enough of generated code...let's do something

We will create a pretty landing page and list all the known users. Let's do it...

### We will haml instead of ERB, because... we are lazy and like to code the less possible

Replace the file **app/views/layouts/application.html.erb** with one called **app/views/layouts/application.html.haml**

Copy this converted content from erb to haml there:

```haml
!!!
%html
  %head
    %title InTouch
    = stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true
    = javascript_include_tag "application", "data-turbolinks-track" => true
    = csrf_meta_tags
  %body
    %p.notice= notice
    %p.alert= alert
    = yield
```

### Defining the generic layout

- Top Bar
-- Display the logged in user
-- Display a link to the logout action
- Place to display notifications to the user
- Footer


#### Bootstrap helps us having the topbar, so lets install it and add a topbar to the layout

```
rails generate bootstrap:install -f
```

The engine that we have just intalled has changed the main layout. It has added a topbar! That does not look bad!
Lets, change back the title to inTouch, and then change the *Project name* to inTouch.

Let's also delete the navigation links, we are not going to need them:

- Home
- About
- Contact

Refresh your webpage, it just looks a little bit better. If you watch closely the recently generated layout, there is a piece of code iterating a flash object, and rendering a box, everytime a new flash message is added to the controller (*devise* uses this remember?)

We will now keep the top bar logic separated from the main layout, so we can isolate its responsability and make it easier to maintain or replace in the future. To do that we will use a rails partial, which is a separate template that we can invoke from the application layout.

- Create a file app/views/layouts/_topbar.html.haml
- Move this code from the app/views/layouts/application.html.haml to app/views/layouts/_topbar.html.haml ```
.navbar.navbar-inverse.navbar-fixed-top
  .container
    .navbar-header
      %button.navbar-toggle{:type => "button", :data => {:toggle => "collapse", :target => ".navbar-collapse"} }
        %span.icon-bar
        %span.icon-bar
        %span.icon-bar
      = link_to "inTouch", "#", :class => "navbar-brand"
```

Refresh the page!

Now lets add the detail of the logged in user to the topbar, on the corner, and a logout link.

On the topbar file, lets add this under the container div

```
%ul.nav.navbar-nav.navbar-right
  %li.dropdown
    %a.dropdown-toggle{"data-toggle" => "dropdown", href: "#"}
      = current_user.email
      %b.caret
    %ul.dropdown-menu
      %li
        %a{href: "#"} Settings
      %li
        %a{href: "#"} Logout
```


Now we need to update those two links to the correct path.

Lets take a look at our routes:

```
rake routes
```

The route that allows us to edit a user account is *named* edit_user_registration. Rails generated two helper methods per route, available on all views, *route_name***_path** and *route_name***_url**.

To have a link to the user account we will use one of these methods combining it with the *link_to* method that generates a well formed html link. Replace `%a{href: "#"} Settings` with `= link_to "Settings", edit_user_registration_path`

Refresh the page... and **It works!** 

Do the same for the Logout link..

Refresh the page... and...The rails complains that the HTTP verb GET is not correct...
Well that is our fault, our route is expecting the DELETE verb, but we are using a simple link to try do destroy our session an logout of the application. We are going to have to use a form...or make use of jquery_ujs.js that will help us do that without many changes to the code.

Check that `//= require jquery_ujs` is on app/assets/javascripts/application.js. If it is not..add it.

Replace your `= link_to "Logout", destroy_user_session_path`  with `= link_to "Logout", destroy_user_session_path , :method => :delete` and it will work.

If you want more details about what jquery_ujs black magic is, go to [https://github.com/rails/jquery-ujs](https://github.com/rails/jquery-ujs)

Refresh the page... and...another problem??
The message indicates that we are trying to access *current_user*..but wait...we've logged out..there is no *current_user*. We will fix that with a simple if on the view:

Add `- if user_signed_in?` on the line before `%ul.nav.navbar-nav.navbar-right` and make all that `%ul` content under the if (meaning you ident everything two spaces forward)

Refresh... and it is now working. Top Bar is finished!

#### Lets display all the users

We want to list all the users, so we will need to fetch them from the database. Go to the file *app/controllers/intouch_controller.rb* and make the index method be like this:

```ruby
def index
    @users = User.all
end
```

Now modify the file *app/views/intouch/index.html.haml* to be like this:

```haml
%h1 Users
%hr
%ul.list-unstyled
  = render partial: "user", collection: @users
```

Add a partial template *app/views/intouch/_user.html.haml*

```haml
%li
  = user.email
```

If we want to make our method respond with different output formats (as an example JSON), we would just have to change it to be like this:

```ruby
def index
    @users = User.all
    respond_to do |format|
      format.html  # index.html.haml
      format.json  { render :json => @users }
    end
end
```

Refresh

#### A cool footer

Edit your application layout **app/views/layouts/application.html.haml** and add a reference to a footer partial right after `= yield`:

```haml
= render "layouts/footer"
```
Create your footer partial **app/views/layouts/_footer.html.haml**:

```haml
.navbar.navbar-fixed-bottom.navbar-inverse.big-footer
  .container
    .row
      %ul.nav.navbar-nav.pull-right
        %li        
          %a{href: "#", style:'text-decoration:none'}
            %span{style:'font-size:4em'}
              This is a cool footer
              %span.glyphicon.glyphicon-thumbs-up
    .row
      %ul.nav.navbar-nav
        %li
          %a{href: "#", style:'text-decoration:none'}
            %strong 
              inTouch
              %small &copy;
```
**Refresh the page**

Go into rails console and add more users :

```
rails console
User.create!(:email => 'user@example.com', :password => 'password', :password_confirmation => 'password')
```

**Refresh the page**

# Step 6 - Lets design our entity model

These is what we are going to have

- User
⋅⋅* Email
..* First Name
..* Second Name
..* Password

- Contact
..* User
..* Virtual Address
..* Contact Type

- Contact Type
..* descriptor


In SQL, belongs to would mean that out entity would reference the owner through a foreign_key.
In other hand, the **has** concept would be mapped by a foreign key to the other entity pointing to the current one.
How is it done on *Rails*? Easy...

### We will start by adding the contact type

```ruby
rails g model ContactType descriptor:string
```

This will generate a model Class named ContactType, a migration that will create the table on the database,
and some test files!


We know that a ContactType will have many contacts that will fall under this category,
so we will go into file **app/models/contact_type.rb** and under the class we will declare this relation:

```ruby
class ContactType < ActiveRecord::Base
  has_many :contacts
end
```

### Create the contact table

A contact will belong to a User that will have many contacts.
It is a simple belongs_to relationship from the Contact to the user.
And the contact will also belong_to a ContactType  group.
Rails generators support this, so lets generate this entity.

```ruby
rails g model Contact user:references contact_type:references v_address:string
```

Run the migrations

```
rake db:migrate
```

### Add the entities to the admin 

```
rails generate active_admin:resource Contact
rails generate active_admin:resource ContactType
```

If you enter the contact page, user dropdown list shows the memory reference for user and for the contact_type... not pretty...
Fix that by overriding the **to_s** method on User class **app/models/user.rb** and on the ContactType on **app/models/contact_type.rb**:

- User
```
 def to_s
    email
  end
```

- ContactType
```
 def to_s
   descriptor
 end
```


If we also try to create a new user, contact, or contact type an error will popup. This is because the admin interface
does not know which params are safe to use when creating an object. This can be solved by

Edit the file **app/admin/contact_type.rb** and set allowed parameters that we expect to come from the interface:

```
controller do
    def permitted_params
      params.permit(:contact_type => [:descriptor])
    end
end

```

Edit the file **app/admin/contact.rb** and set allowed parameters that we expect to come from the interface:

```
controller do
    def permitted_params
      params.permit(:contact => [:user_id, :contact_type_id, :v_address])
    end
end

```


Edit the file **app/admin/user.rb** to customize and set the allowed parameters that we expect to come from the interface:


```
  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
    end

    f.actions
  end


  controller do
    def permitted_params
      params.permit(:user => [:email, :password, :password_confirmation])
    end
  end
```

Right now we are able to manage things from the interface... but we actually want the user to be able to input his own contacts.

# Step 8 - Change the user settings account

First we will change what are the fields for the user registration to include the First Name and Last name

#### Create the migration
```
rails g migration add_first_name_last_name_to_user
```

Change the change method of the migration file **db/migrate/<timestamp>_** to include two more fields:

```ruby
  def change
    change_table :users do |t|
      t.string :first_name , null: false
      t.string :last_name, null: false
    end
  end
```

Run the migrations!

```
rake db:migrations
```

No we want to customize the way a registration logic exists to add two more fields.
Rails4 introduced a concept called strong parameters, that basically means that we whitelist all the fields we are expecting to come from a request.
We added two more fields, so we need to tell **devise** (the engine we are using to manage our registrations + authentication),
to trust the **first_name** and **last_name** parameters.

We will extend the Devise Registrations controller to do this. To do that we will first use a rails generator to generate ours.

```
rails g controller Users::Registrations
```

If you open the file **app/controllers/registrations_controller.rb** you will notice that it is extending ApplicationController,
that is the base controller for anything on rails.

Change that to extend the devise one:
```
class Users::RegistrationsController < Devise::RegistrationsController
...
```

Add a method that will extend devise whitelisted parameters

```ruby
before_filter :configure_permitted_parameters


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name]
    devise_parameter_sanitizer.for(:account_update) << [:first_name, :last_name]
  end
```

Now we have to tell devise to reference our controller instead of the default one. Open **config/routes.rb**

Replace the line `devise_for :users` with `devise_for :users, :controllers => {:registrations => 'users/registrations'}`

As we replaced the default controller the default views will no longer work. This way we are going to have create two new views:

- **app/views/users/new.html.haml**
- **app/views/users/edit.html.haml**

Put this content on the first one:

```haml
%h2 Sign up
= form_for(resource, :as => resource_name, :url => registration_path(resource_name)) do |f|
  = devise_error_messages!
  %div
    = f.label :email
    %br/
    = f.email_field :email, :autofocus => true
  %div
    = f.label :first_name
    %br/
    = f.text_field :first_name
    %div
      = f.label :last_name
      %br/
      = f.text_field :last_name
  %div
    = f.label :password
    %br/
    = f.password_field :password
  %div
    = f.label :password_confirmation
    %br/
    = f.password_field :password_confirmation

  %div= f.submit "Sign up"
= render "devise/shared/links"
```

Put this content on the second one:

```haml
%h2
  Edit #{resource_name.to_s.humanize}
= form_for(resource, :as => resource_name, :url => registration_path(resource_name), :html => { :method => :put }) do |f|
  = devise_error_messages!
  %div
    = f.label :email
    %br/
    = f.email_field :email, :autofocus => true
  %div
    = f.label :first_name
    %br/
    = f.text_field :first_name
  %div
    = f.label :last_name
    %br/
    = f.text_field :last_name

  - if devise_mapping.confirmable? && resource.pending_reconfirmation?
    %div
      Currently waiting confirmation for: #{resource.unconfirmed_email}
  %div
    = f.label :password
    %i (leave blank if you don't want to change it)
    %br/
    = f.password_field :password, :autocomplete => "off"
  %div
    = f.label :password_confirmation
    %br/
    = f.password_field :password_confirmation
  %div
    = f.label :current_password
    %i (we need your current password to confirm your changes)
    %br/
    = f.password_field :current_password
  %div= f.submit "Update"
%h3 Cancel my account
%p
  Unhappy? #{button_to "Cancel my account", registration_path(resource_name), :data => { :confirm => "Are you sure?" }, :method => :delete}
= link_to "Back", :back
```

Now we will change what we display on the top bar when we are logged in.
Go into the file **app/helpers/intouch_helper.rb** and create a helper method that will display our full name

```ruby
  def full_name(user)
     "#{user.first_name} #{user.last_name}"
  end
```

Now open **/app/views/layouts/_topbar.html.haml**

and replace  `= current_user.email` with `full_name(current_user)`

## Creating the manage contacts page


Create the contacts controller

```
rails g controller Contacts
```

Add a new resource to your routes **config/routes.rb**

```ruby
resources :contacts
```

run `rake routes` and seed which are the defaults generated by that line for contacts.




# Step 9 - Display the contacts of an user alongside with him


# Step 10 - Add an image to an user


# Step 11 - Integrate with facebook




