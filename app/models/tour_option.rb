class TourOption < ApplicationRecord
  belongs_to :tour
  belongs_to :option
end
