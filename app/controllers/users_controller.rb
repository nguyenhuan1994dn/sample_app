class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page],
      per_page: Settings.users_per_page
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "controllers.users_controller.welcome"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controllers.users_controller.update_user"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controllers.users_controller.del_user"
    else
      flash[:danger] = t "controllers.users_controller.user_not_found"
    end
    redirect_to users_path
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controllers.users_controller.user_not_found"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controllers.users_controller.pls_log_in"
    redirect_to login_path
  end

  def correct_user
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
