class SessionsController < ApplicationController
  def new
    
  end
  def create
    if session_params[:email].blank? || session_params[:password].blank?
      flash.now[:danger] = "Email or password can't be blank"
      render 'new'
    else
      user = User.find_by(email: session_params[:email].downcase)
      if user && user.authenticate(session_params[:password])
        sign_in user
        redirect_to user
      else
        flash.now[:danger] = "Invalid email/password combination"
        render 'new'
      end
    end
  end
  def destroy
    sign_out
    redirect_to root_url
  end

  private
    def session_params
      params.require(:session).permit(:email, :password)
    end
end
