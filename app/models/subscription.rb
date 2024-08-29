class Subscription < ApplicationRecord
  VALID_CHANNELS = %w[email telegram].freeze

  enum subscription_type: {
    weekly_report: 0
  }

  belongs_to :user

  validates :subscription_type, presence: true
  validates :user_id, uniqueness: { scope: :subscription_type }
end
