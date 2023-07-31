module API
  module Entities
    class TourList < Grape::Entity
      expose :id
      expose :name
      expose :visit_location
      expose :cost
      expose :average_rate
    end
  end
end
