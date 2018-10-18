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

  private

  def check_session_status user
    if params[:session][:remember_me] == Settings.sessions.check_session
      remember user
    else
      forget user
    end
  end

  def check user
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        check_session_status user
        redirect_back_or user
      else
        flash[:warning] = t "controllers.sessions_controller.check_email"
        redirect_to root_path
      end
    else
      flash.now[:danger] = t "controllers.sessions_controller.invalid"
      render :new
    end
  end
end
