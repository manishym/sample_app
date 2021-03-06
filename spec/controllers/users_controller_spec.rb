require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    it "Should have right title" do
      get 'new'
      response.should have_selector('title', :content => "Sign up")
    end 
    it "should have a name field" do 
      get :new
      response.should have_selector("input[name='user[name]'] [type='text']")
    end
    it "should have a email field" do
      get :new
      response.should have_selector("input[name='user[email]'] [type='text']")
    end
    it "should have a email field" do
      get :new
      response.should have_selector("input[name='user[password]'] [type='password']")
    end
    it "should have a email field" do
      get :new
      response.should have_selector("input[name='user[password_confirmation]'] [type='password']")
    end
  end
  describe "GET 'show'" do
    before(:each) do
          @user = Factory(:user)
    end
    it "should be successful" do
      get :show, :id => @user
      response.should be_success 
    end
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
  end
  describe "POST 'create' " do
    describe "Failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "", 
                  :password_confirmation => ""}
      end
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)  
      end
      it "should have the right title" do
              post :create, :user => @attr
              response.should have_selector("title", :content => "Sign up")
      end
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new') 
      end
    end
    describe "Success" do
      before(:each) do
        @attr = {:name => "New user", :email => "user@example.com", 
                  :password => "foobar", :password_confirmation => "foobar"}
      end
      it "should create a user" do
        lambda do
          post :create, :user => @attr 
        end.should change(User, :count).by(1)
      end
      it "should redirect to the show user page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i 
      end
      it "should sign the new user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end
  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in @user
    end
    
    it "should be successful" do
      get :edit, :id => @user 
      response.should be_success
    end
    it "should have the right title" do
      get :edit, :id => @user 
      response.should have_selector("title", :content => "Edit user")
    end
    it "should have the link to change gravatar" do
      gravatar_url = "http://gravatar.com/emails"
      get :edit, :id => @user 
      response.should have_selector("a", :href => gravatar_url,
                                          :content => "change", )
    end
  end
  describe "PUT 'update'" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      describe "failure" do

        before(:each) do
          @attr = { :email => "", :name => "", :password => "",
                    :password_confirmation => "" }
        end

        it "should render the 'edit' page" do
          put :update, :id => @user, :user => @attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @user, :user => @attr
          response.should have_selector("title", :content => "Edit user")
        end
        
        
      end

      describe "success" do

        before(:each) do
          @attr = { :name => "New Name", :email => "user@example.org",
                    :password => "barbaz", :password_confirmation => "barbaz" }
        end

        it "should change the user's attributes" do
          put :update, :id => @user, :user => @attr
          @user.reload
          @user.name.should  == @attr[:name]
          @user.email.should == @attr[:email]
        end

        it "should redirect to the user show page" do
          put :update, :id => @user, :user => @attr
          response.should redirect_to(user_path(@user))
        end

        it "should have a flash message" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /updated/
        end
        describe "for signed-in users" do

              before(:each) do
                wrong_user = Factory(:user, :email => "user@example.net")
                test_sign_in(wrong_user)
              end

              it "should require matching users for 'edit'" do
                get :edit, :id => @user
                response.should redirect_to(root_path)
              end

              it "should require matching users for 'update'" do
                put :update, :id => @user, :user => {}
                response.should redirect_to(root_path)
              end
        end
      end
      
    
  end
  describe "authentication of edit/update pages" do

      before(:each) do
        @user = Factory(:user)
      end

      describe "for non-signed-in users" do

        it "should deny access to 'edit'" do
          get :edit, :id => @user
          response.should redirect_to(signin_path)
        end

        it "should deny access to 'update'" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(signin_path)
        end
      end
  end
  describe "GET 'index' " do
    describe "For not signed in users" do
      it "Should deny access" do
        get :index
        response.should redirect_to signin_path
      end
    end
    describe "For signed in users" do
      before(:each) do
        @user = Factory(:user)
        # add few more users to database, to display them all in index
        second = Factory(:user, :email => "ma.ni.sh.ym@gmail.com")
        third = Factory(:user, :email => "example@gmail.com")
        test_sign_in @user
        @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email)) 
        end
        
      end
      it "should show users index page" do
        get :index
        response.should be_success
      end
      it "should have right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end
      it "should display each user in a li element" do
        get :index
        User.all.each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end
      it "should have a link to user" do
        get :index
        User.all.each do |user|
          # have not figured out how to add link to user show page
          response.should have_selector("a",:content => user.name)#, :href => user_path, )
        end
      end
      it "should paginate users" do
        get :index
        response.should have_selector ("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",
                                            :content => "Next")
        response.should have_selector("a", :href => "/users?page=2",
                                            :content => "2")
        
      end
      it "signed in admin should have links to delete users" do
        admin = Factory(:user, :email => "admin@example.org")
        test_sign_in(admin)
        admin.toggle!(:admin)
        user = User.all.second
        get :index
        response.should have_selector("a", :href => user_path(user),
                                            :content => "delete")
        
      end
      it "should not show delete link to not signed in user" do   
        get :index 
        user = User.all.second
        response.should_not have_selector("a", :href => user_path(user),
                                            :content => "delete")
            
      end
      it "Should not show delete link to signed in no admin user" do
        get :index 
        user = User.all.second
        test_sign_in (user)
        response.should_not have_selector("a", :href => user_path(user),
                                            :content => "delete")
      end
    end  
  end
  describe "DELETE 'destroy'" do
    before(:each) do
      @user = Factory(:user, :email => "admin@example.com")
      @another_user = Factory(:user, :email => "second@example.com")
      test_sign_in @user
    end
    
    it "Should not delete a user if non admin deletes" do
      test_sign_in @user
      delete :destroy, :id => @user 
      response.should redirect_to(root_path)
      
    end
    it "Should delete a user if admin deletes" do
      @user.toggle!(:admin)
       lambda do
          delete :destroy, :id => @another_user
        end.should change(User, :count).by(-1)
      
    end
    it "admin should not be able to delete himself" do
      @user.toggle! :admin
      lambda do
        delete :destroy, :id => @user 
      end.should_not change(User, :count)
    end
  end
end

