class Order < ApplicationRecord
  belongs_to :tour
  belongs_to :user

  enum status: {pending: 0, approved: 1, cancelled: 2}
  validates :amount_member, :total_cost, presence: true
end
