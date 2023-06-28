class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    authenticate_user @user
  end

  def destroy
    log_out if logged_in?
    redirect_to login_path
  end

  private
  def authenticate_user user
    if user.authenticate params.dig(:session, :password)
      log_in user
      params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
      if user.admin?
        redirect_to admin_tours_path
      else
        redirect_to root_path
      end
    else
      flash.now[:danger] = t "sessions.flash.login_failed"
      render :new
    end
  end

  def load_user
    @user = User.find_by email: params.dig(:session, :email).downcase
    return if @user

    flash.now[:danger] = t "sessions.flash.user_not_found"
    render :new
  end
end
