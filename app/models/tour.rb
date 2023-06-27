class Tour < ApplicationRecord
  before_save :compare_date, :downcase_name

  validates :name, presence: true, length: {
    maximum: Settings.max_length_name_100,
    minimum: Settings.min_length_name_10
  }
  validates :description, presence: true,
                          length: {minimum: Settings.min_length_name_10}
  validates :start_date, :end_date, :cost, :visit_location,
            :start_location, presence: true
  validates :image, content_type: {in: %w(image/jpeg image/gif image/png)},
                    size: {less_than: Settings.max_5.megabytes}

  scope :filter_by_category, ->(category_id){where category_id: category_id}
  scope :filter_by_name, ->(name){where name: name}

  belongs_to :category

  has_one_attached :image

  def downcase_name
    name.downcase!
  end

  def compare_date
    errors.add(:end_date, t("tours.compare_date")) if start_date > end_date
  end

  def display_image
    image.variant resize_to_limit: [
      Settings.image_size_400,
                                    Settings.image_size_400
    ]
  end
end
