class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:email]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user)
    else
      redirect_to :back, notice: "Email and/or password mismatch"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to signin_path
  end
end
