class Category < ApplicationRecord
  acts_as_list scope: [:parent_id]

  belongs_to :user
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  has_many :periods, dependent: :destroy
  has_one :goal, dependent: :destroy
  has_many :reports, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :color, inclusion: { in: BG_COLORS.values.flatten }

  scope :sorted, -> { order(position: :asc) }

  after_save :update_level

  def self.ransackable_attributes(auth_object = nil)
    ["color", "created_at", "id", "id_value", "level", "name", "parent_id", "position", "updated_at", "user_id"]
  end

  def total_seconds
    start_date = Date.new(2000, 1, 1)
    total_seconds = CategoriesAnalyticsService.total_time_in_range(self, start_date, Time.current)
  end

  def formatted_total_time
    CategoriesAnalyticsService.seconds_to_time_format(total_seconds)
  end

  def can_have_timer?
    children.blank?
  end

  def self.any_unfinished_periods_for_user(user)
    user.categories.joins(:periods).where(periods: { end: nil }).exists?
  end  

  def descendants
    children.flat_map { |child| [child] + child.descendants }
  end

  def update_level
    new_level = parent.nil? ? 1 : parent.level + 1
    update_column(:level, new_level) if level != new_level
  
    children.each(&:update_level)
  end

  def ids_including_children
    ids = [self.id]
    children.each do |child|
      ids.concat(child.ids_including_children)
    end
    ids
  end

  def all_periods
    periods + children.flat_map(&:all_periods)
  end
end
