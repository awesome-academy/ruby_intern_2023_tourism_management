class Order < ApplicationRecord
  belongs_to :tour
  belongs_to :user

  delegate :name, :phone, :email, :address, to: :user, prefix: true, allow_nil: true
  delegate :name, :image, :cost, :start_date, :end_date, :tour_guide_cost, to: :tour, prefix: true, allow_nil: true

  enum status: {pending: 0, approved: 1, cancelled: 2}
  validates :amount_member, :contact_name, :contact_phone, :contact_address, presence: true

  def display_image
    tour_image.variant resize_to_limit: Array.new(Settings.limit_image_area)
  end
end
