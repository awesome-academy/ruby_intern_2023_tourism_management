class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable,
         :registerable, :confirmable, :lockable, :trackable

  has_many :orders, dependent: :destroy

  enum role: {guest: 0, admin: 1, user: 2}

  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.max_length_name_20}
  validates :email, presence: true, length: {maximum: Settings.max_length_email_255},
    format: {with: Regexp.new(Settings.valid_email_regex)}, uniqueness: {case_sensitive: false}

  private

  def downcase_email
    email.downcase!
  end
end
