require "jwt"

class Authentication
  ALGORITHM = "HS256".freeze

  class << self
    def encode payload
      payload[:exp] = Settings.expired_time_token.hours.from_now.to_i
      jti_raw = [ENV["secret_ket"], Time.zone.now].join(":").to_s
      payload[:jti] = Digest::MD5.hexdigest(jti_raw)
      update_jti payload[:user_id], payload[:jti]
      JWT.encode(payload, ENV["secret_ket"], ALGORITHM)
    end

    def decode token
      decode_token = JWT.decode(token, ENV["secret_ket"], true, {algorithm: ALGORITHM}).first
      raise JWT::DecodeError unless validate_jti decode_token["user_id"], decode_token["jti"]

      decode_token
    end

    def update_jti id, jti
      user = User.find_by id: id
      user.update_columns jti: jti
    end

    def validate_jti id, jti
      user = User.find_by id: id
      user.jti == jti
    end
  end
end
