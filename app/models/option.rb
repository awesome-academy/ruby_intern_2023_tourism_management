class Option < ApplicationRecord
  has_many :tours, through: :tour_options
  has_many :tour_options, dependent: :destroy

  has_rich_text :option_content

  scope :not_in_tour, ->(tour_id){where.not(id: TourOption.where(tour_id: tour_id).pluck(:option_id))}

  validates :option_name, uniqueness: true, presence: true,
            length: {maximum: Settings.max_length_text_254, minimum: Settings.min_length_text_10}
  validates :option_cost, numericality: {only_integer: true, greater_than: 0}
  validates :option_content, :option_cost, presence: true
end
