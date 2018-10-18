class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "controllers.account_activations_controller.actived"
      redirect_to user
    else
      flash[:danger] = t "controllers.account_activations_controller.invalid"
      redirect_to root_path
    end
  end
end
