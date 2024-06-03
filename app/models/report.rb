class Report < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :start_date, :end_date, presence: true
  validates :unique_identifier, uniqueness: true

  before_validation :generate_unique_identifier, on: :create

  def to_param
    unique_identifier
  end
  
  private

  def generate_unique_identifier
    self.unique_identifier = loop do
      token = SecureRandom.uuid
      break token unless Report.exists?(unique_identifier: token)
    end
  end
end
