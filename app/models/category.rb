class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true,
                  length: {
                    minimun: Settings.min_length_name_10,
                    maximum: Settings.max_length_name_100
                  }
  validates :description, :duration, presence: true

  has_many :tours, dependent: :destroy
end
