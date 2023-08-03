module API
  module Entities
    class Order < Grape::Entity
      expose :id
      expose :tour
      expose :user
      expose :note
      expose :status
      expose :amount_member
      expose :tour_guide
      expose :total_cost
      expose :contact_name
      expose :contact_phone
      expose :contact_address
      expose :service_option
    end
  end
end
