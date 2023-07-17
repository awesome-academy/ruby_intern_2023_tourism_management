class Tour < ApplicationRecord
  belongs_to :category
  has_many :orders, dependent: :restrict_with_exception
  has_many :comments, through: :orders
  has_one_attached :image
  has_rich_text :content

  attr_accessor :is_create_category

  accepts_nested_attributes_for :category

  delegate :name, to: :category, prefix: true, allow_nil: true

  ransack_alias :tour, :name_or_description_or_visit_location_or_start_location_or_category_name
  ransacker :created_at, type: :date do
    Arel.sql("date(created_at)")
  end

  validates :name, uniqueness: true, presence: true,
            length: {maximum: Settings.max_length_text_254, minimum: Settings.min_length_text_10}
  validates :description, presence: true, length: {minimum: Settings.min_length_text_10}
  validates :cost, :tour_guide_cost, :start_date, :end_date, :visit_location, :start_location, :content, presence: true
  validate :compare_date
  validates :image, presence: true, allow_nil: true,
            content_type: {in: Array.new(Settings.validate_image_format),
                           message: I18n.t("admin.tours.validate.valid_image_format")},
            size: {less_than: Settings.max_image_size_5_MB.megabytes,
                   message: I18n.t("admin.tours.validate.less_than_5MB_image_size")}
  validates :cost, :tour_guide_cost, numericality: {only_integer: true, greater_than: 0}

  def compare_date
    errors.add(:end_date, I18n.t("tours.compare_date")) if start_date && end_date && start_date > end_date
    errors.add(:end_date, I18n.t("tours.before_today")) if before_today?(end_date)
    errors.add(:start_date, I18n.t("tours.before_today")) if before_today?(start_date)
  end

  def display_image
    image.variant resize_to_limit: Array.new(Settings.limit_image_area)
  end

  def before_today? check_date
    check_date && check_date < Time.zone.today
  end

  def update_average_rate
    average_rate = comments.average(:rate)
    update_columns average_rate: average_rate
  end
end
