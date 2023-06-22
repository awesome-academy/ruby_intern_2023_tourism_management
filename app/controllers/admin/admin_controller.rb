class Admin::AdminController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    return if current_user.admin?

    flash[:danger] = t "admin.unauthorized"
    redirect_to login_path
  end
end
