module AuthHelper
  extend Grape::API::Helpers

  def api_error! message, error_code, status = nil, header = nil
    error!({message: message, code: error_code}, status, header)
  end

  def authenticate_user!
    @current_user = current_user
    return if @current_user

    api_error!("Unauthorize", 401)
  rescue JWT::DecodeError
    api_error!("Token invalid", 401)
  end

  def current_user
    token = request.headers["Authorization"]
    user_id = Authentication.decode(token)["user_id"] if token
    User.find_by id: user_id
  end
end
