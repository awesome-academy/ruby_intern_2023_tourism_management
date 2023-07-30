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
        end
      end
    end
  end
end
