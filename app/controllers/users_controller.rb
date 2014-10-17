class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :new_user, only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end
  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 20)
  end
  def create
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App, #{@user.name}!"
 			redirect_to @user
  	else
  		render 'new'
  	end
  end
  def edit
    # @user = User.find(params[:id])
  end
  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  def destroy
    user = User.find(params[:id])
    unless user == current_user && user.admin?
      flash[:success] = "User deleted."
      user.destroy
    else
      flash[:danger] = "Admin cannot delete self"
    end
    redirect_to users_url
  end

  private
  	# Returns filtered and safe params
  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    def new_user
      redirect_to root_url if signed_in?
    end
end
