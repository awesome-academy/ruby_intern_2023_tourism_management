require_relative "./helpers/auth_helper"

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
        rescue_from ::CanCan::AccessDenied do
          error!("Access Denied", 403)
        end
        helpers AuthHelper
      end
    end
  end
end
