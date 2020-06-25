class SessionsController < ApplicationController
  def new
    session_notice('warning', 'Already logged in!') if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user&.authenticate(params[:session][:password])
      log_in(user)
      flash[:success] = "Welcome #{user.name} !"
      redirect_to user
    else
      flash.now[:danger] = 'Email and password miss match'
      render :new
    end

  end

  def destroy
    log_out
    redirect_to root_path
  end
end
