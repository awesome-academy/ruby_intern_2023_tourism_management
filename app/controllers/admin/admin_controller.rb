class Admin::AdminController < ApplicationController
  before_action :required_login, :require_admin

  private

  def require_admin
    return if current_user.admin?

    flash[:danger] = t "admin.unauthorized"
    redirect_to login_path
  end

  def required_login
    return if current_user

    flash[:danger] = t "admin.login_required"
    redirect_to login_path
  end
end
