class UsersController < ApplicationController
  load_and_authorize_resource
  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found

  def show; end

  private
  def user_not_found
    flash[:danger] = t "users.flash.user_not_found"
    redirect_to root_path
  end
end
