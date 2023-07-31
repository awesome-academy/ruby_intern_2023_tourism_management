module API
  module Entities
    class Tour < Grape::Entity
      expose :id
      expose :name
      expose :description
      expose :cost
      expose :visit_location
      expose :start_location
      expose :average_rate
      expose :start_date do |tour|
        I18n.l(tour.start_date)
      end
      expose :end_date do |tour|
        I18n.l(tour.end_date)
      end
      expose :image_url do |tour|
        Rails.application.routes.url_helpers.rails_blob_url(tour.image, host: ENV["host"])
      end
      expose :content do |tour|
        tour.content.body
      end
      expose :comments
      expose :options
    end

    class TourList < Grape::Entity
      expose :id
      expose :name
      expose :visit_location
      expose :cost
      expose :average_rate
    end
  end
end
