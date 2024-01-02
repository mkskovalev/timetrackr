class Period < ApplicationRecord
  belongs_to :category, dependent: :destroy

  validates :start, :end, presence: true
end
