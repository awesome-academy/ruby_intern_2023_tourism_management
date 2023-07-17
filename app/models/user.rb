class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable,
         :registerable, :confirmable, :lockable, :trackable

  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum role: {guest: 0, admin: 1, user: 2}

  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.max_length_name_20}
  validates :email, presence: true, length: {maximum: Settings.max_length_email_255},
    format: {with: Regexp.new(Settings.valid_email_regex)}, uniqueness: {case_sensitive: false}

  def send_email_approved_order
    UserMailer.order_approved(email).deliver_later
  end

  def send_email_cancelled_order
    UserMailer.order_cancelled(email).deliver_later
  end

  private

  def downcase_email
    email.downcase!
  end
end
