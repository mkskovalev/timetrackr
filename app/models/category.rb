class Category < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :periods

  validates :name, presence: true
end
