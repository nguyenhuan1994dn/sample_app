class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
    only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if !@user
      flash.now[:danger] = t "controllers.password_resets_controller.e_notfound"
      render :new
    else
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "controllers.password_resets_controller.email_sent"
      redirect_to root_path
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password,
        t("controllers.password_resets_controller.pass_error"))
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t "controllers.password_resets_controller.reset_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = t "controllers.password_resets_controller.user_notfound"
    redirect_to root_path
  end

  def valid_user
    return if @user&.activated? &&
              @user.authenticated?(:reset, params[:id])
    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "controllers.password_resets_controller.expire_pass"
    redirect_to new_password_reset_path
  end
end
