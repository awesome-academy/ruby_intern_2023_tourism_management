module API
  module V1
    module Defaults
      extend ActiveSupport::Concern
      included do
        prefix :api
        version "v1", using: :path
        default_format :json
        format :json
        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end
        helpers do
          def api_error! message, error_code, status = nil, header = nil
            error!({message: message, code: error_code}, status, header)
          end

          def authenticate_user!
            token = request.headers["Authorization"]
            user_id = Authentication.decode(token)["user_id"] if token
            @current_user = User.find_by id: user_id
            return if @current_user

            api_error!("Unauthorize", 401)
          rescue JWT::DecodeError
            api_error!("Token invalid", 401)
          end
        end
      end
    end
  end
end
