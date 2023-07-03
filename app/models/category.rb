class Category < ApplicationRecord
  has_many :tours, dependent: :restrict_with_exception

  scope :by_id, ->(category_id){where id: category_id}

  validates :name, presence: true, uniqueness: true,
                  length: {maximum: Settings.max_length_text_100, minimum: Settings.min_length_text_10}
  validates :description, presence: true
  validates :duration, presence: true, numericality: {only_integer: true, greater_than: 0}
end
