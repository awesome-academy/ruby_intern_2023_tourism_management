class Tour < ApplicationRecord
  belongs_to :category
  has_many :orders, dependent: :restrict_with_exception
  has_one_attached :image

  delegate :name, to: :category, prefix: true, allow_nil: true

  scope :filter_by_category, ->(category_id){where category_id: category_id}
  scope :filter_by_name, ->(name){where name: name}
  scope :newest, ->{order updated_at: :desc}

  validates :name, presence: true, length: {maximum: Settings.max_length_text_254, minimum: Settings.min_length_text_10}
  validates :description, presence: true, length: {minimum: Settings.min_length_text_10}
  validates :start_date, :end_date, :cost, :visit_location, :start_location, presence: true
  validates :image, content_type: {in: Array.new(Settings.validate_image_format),
                                   message: I18n.t("admin.tours.validate.valid_image_format")},
                    size: {less_than: Settings.max_image_size_5_MB.megabytes,
                           message: I18n.t("admin.tours.validate.less_than_5MB_image_size")}

  def compare_date
    errors.add(:end_date, t("tours.compare_date")) if start_date > end_date
  end

  def display_image
    image.variant resize_to_limit: Array.new(Settings.limit_image_area)
  end
end
