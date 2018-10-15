class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    check user
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def check user
    if user&.authenticate(params[:session][:password])
      log_in user
      if params[:session][:remember_me] == Settings.sessions.check_session
        remember(user)
      else
        forget(user)
      end
      redirect_to user
    else
      flash.now[:danger] = t "controllers.sessions_controller.invalid"
      render :new
    end
  end
end
