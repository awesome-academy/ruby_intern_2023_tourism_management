module API
  module V1
    class Auth < Grape::API
      include API::V1::Defaults

      helpers do
        def represent_user_with_token user
          present jwt_token: Authentication.encode({user_id: user.id})
        end
      end

      namespace :auth do
        desc "User login"
        params do
          requires :email, type: String, desc: "User email"
          requires :password, type: String, desc: "User password"
        end
        post "/login" do
          user = User.find_for_authentication(email: params[:email])
          if user&.valid_password?(params[:password])
            represent_user_with_token user
          else
            api_error!("Invalid email or password", 401)
          end
        end

        desc "User logout"
        before do
          authenticate_user!
        end
        delete "/logout" do
          @current_user.update_columns jti: nil
          @current_user = nil
          {status: "success", message: "Logged out successfully"}
        end
      end
    end
  end
end
