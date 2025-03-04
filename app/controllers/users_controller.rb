require "user_chat"

class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[edit update]
  before_action :load_user, only: %i[show edit update]

  def index; end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      UserChat.creat_room_chat(@user.email, @user.id)
      flash[:info] = t("flash.info.signup_success")
      redirect_to root_url
    else
      render "new"
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t("flash.success.profile_update")
      redirect_to @user
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :avatar)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("flash.danger.login_required")
    redirect_to login_url
  end

  def load_user
    @user = User.find_by_id(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def log_in(user)
    session[:user_id] = user.id
  end
end
