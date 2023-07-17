class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :order
  belongs_to :tour

  after_save :update_tour_average_rate

  validates :review, length: {maximum: Settings.max_length_text_500, minimum: Settings.min_length_text_10},
                     allow_blank: true
  validates :rate, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5},
                   allow_blank: true
  validate :review_and_rate_not_both_blank
  private

  def update_tour_average_rate
    tour.update_average_rate
  end

  def review_and_rate_not_both_blank
    return unless review.blank? && rate.blank?

    errors.add(:base, I18n.t("comments.flash.both_blank"))
  end
end
