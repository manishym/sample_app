class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_only, :only => :destroy
  before_filter :not_signed_in, :only => [:new, :create]
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  def new
    @user = User.new
    @title = "Sign up"
  end
  def show
    @user = User.find(params[:id])
    @title = @user.name    
  end
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to ( @user )
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'  
    end
    
  end
  def edit
    @user = User.find(params[:id])
    @title = "Edit user" 
  end
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path
  end
  private
  def authenticate
    deny_access unless signed_in?
  end
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  def admin_only
    user = User.find(params[:id])

    redirect_to root_path if !current_user.admin? || current_user?(user)
  end
  def not_signed_in
    redirect_to root_path, :notice => "Signed in users cannot do that" if signed_in?    
  end
end
