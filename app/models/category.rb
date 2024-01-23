class Category < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :childrens, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  has_many :periods, dependent: :destroy

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

  def total_seconds
    start_date = Date.new(2000, 1, 1)
    total_seconds = CategoriesAnalyticsService.total_time_in_range(self, start_date, Time.current)
  end

  def formatted_total_time
    CategoriesAnalyticsService.seconds_to_time_format(total_seconds)
  end

  def calculated(user)
    self.level(user) == 1 || childrens.blank?
  end

  def self.any_unfinished_periods_for_user(user)
    top_level_categories = user.categories.where(parent_id: nil)
    any_unfinished_periods?(top_level_categories)
  end

  def descendants
    childrens.flat_map { |child| [child] + child.descendants }
  end

  private

  def self.any_unfinished_periods?(categories)
    categories.any? do |category|
      category.periods.any? { |period| period.end.nil? } || any_unfinished_periods?(category.childrens)
    end
  end
end
