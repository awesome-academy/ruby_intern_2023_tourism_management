class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "users.flash.user_not_found"
    redirect_to home_path
  end
end
