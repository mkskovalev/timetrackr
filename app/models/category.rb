class Category < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :childrens, class_name: 'Category', foreign_key: 'parent_id'
  has_many :periods

  validates :name, presence: true

  def self.max_level(user)
    max_level = 0
    Category.where(user_id: user.id).find_each do |category|
      level = 1
      current_category = category
      while current_category.parent.present?
        level += 1
        current_category = current_category.parent
      end
      max_level = [max_level, level].max
    end
    max_level
  end

  def level(user)
    max_depth = Category.max_level(user)
    depth = 1
    current_category = self
    while current_category.parent.present?
      depth += 1
      current_category = current_category.parent
    end
    max_depth - depth + 1
  end

  def total_time
    total_seconds = periods.reduce(0) do |sum, period|
      period_time = period.end ? (DateTime.parse(period.end) - DateTime.parse(period.start)) * 86400 : 0
       sum + period_time
    end

    childrens.each do |child|
      total_seconds += child.total_time
    end

    total_seconds
  end

  def formatted_total_time
    total_seconds = total_time.to_i
    hours = total_seconds / 3600
    minutes = (total_seconds / 60) % 60
    seconds = total_seconds % 60

    format("%02d:%02d:%02d", hours, minutes, seconds)
  end

  def calculated(user)
    self.level(user) == 1 || childrens.blank?
  end

  def self.any_unfinished_periods_for_user(user)
    top_level_categories = user.categories.where(parent_id: nil)
    any_unfinished_periods?(top_level_categories)
  end

  private

  def self.any_unfinished_periods?(categories)
    categories.any? do |category|
      category.periods.where(end: nil).exists? || any_unfinished_periods?(category.childrens)
    end
  end
end
