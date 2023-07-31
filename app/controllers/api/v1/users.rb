module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults
      before do
        authenticate_user!
      end

      authorize_routes!
      resource :users do
        desc "Update users"
        params do
          requires :id, type: Integer, desc: "User id"
          requires :name, type: String, desc: "User name"
          requires :phone, type: String, desc: "User phone"
          requires :address, type: String, desc: "User address"
        end
        put "/:id", authorize: [:read, User] do
          @user = User.find params[:id]
          raise ::CanCan::AccessDenied unless @user == @current_user

          if @user.update name: params[:name], phone: params[:phone], address: params[:address]
            {status: "success", message: "User information updated successfully."}
          else
            api_error!("Can't update user", 422)
          end
        end
      end

      resource :users do
        desc "Change user password"
        params do
          requires :id, type: Integer, desc: "User id"
          requires :password, type: String, desc: "Current password"
          requires :new_password, type: String, desc: "New password"
          requires :confirm_password, type: String, desc: "Confirm password"
        end
        put "/:id/password", authorize: [:update, User] do
          @user = User.find params[:id]
          raise ::CanCan::AccessDenied unless @user == @current_user

          if @user.valid_password?(params[:password])
            @user.reset_password params[:new_password], params[:confirm_password]
            {status: "success", message: "User password updated successfully."}
          else
            api_error!("Invalid email or password", 401)
          end
        end
      end
    end
  end
end
