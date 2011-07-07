# create a test to check for user delete link
# to make it pass link_to "delete", user, :method => :delete, :confirm => "You sure?" 
# Javascript_include_tag :defaults
# make it pass
# define destroy action
# 
# write tests to destroy action
#   For non signed in user, redirect to sign in
#   For non admin user, redirect to root_path
#   For admin user, in a lambda block, checkout for count should be less by one
#   

# Create a delete action
# Make sure only admins can delete
# Make sure a admin won't delete himself/herself










=======================================================================
# done

=======================================================================
# Step 3

# Write tests to verify user responds to admin? method
# To make sure admin is false by default
# To toggle! admin and see if user is admin.

# 
# Create migration add_admin_to_users with admin:boolean option
# rake db:test:prepare
# add :default => false.

=======================================================================
# Step 2

# install faker gem
# create a rake task in lib/tasks folder: sample_data.rake

# add will_paginate gem 
# use User.paginate(:page => params[:page]) instead of


# create test for pagination
#     create Factory sequence to make new email for 30 users
#     Look at source of paginated html code and write tests
#     for pagination
# 
# 


=======================================================================
# Step 1
# write test to casue index to redirect for non signed in user in user_controlled_spec
# make it pass by adding :index to before filter

# write test to cause index pass to signed in user
# make it pass by creating a template

# make test to make sure index has right title.
# make it pass


# make few more users using Factory(:user, :email => "value")
# make a test to make sure User.all.each has a <li> eliment
# make it pass by creating @users variable in controller and
# adding a li in loop for each user in @users

# Integration test for layout
# create a navigation test to test that Users link is present in
# navigation and make it pass



