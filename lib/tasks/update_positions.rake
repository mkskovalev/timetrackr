namespace :category do
  desc "Recalculate positions for all categories"
  task recalculate_positions: :environment do
    Category.where(parent_id: nil).find_each do |parent_category|
      parent_category.children.order(:id).each_with_index do |category, index|
        category.update_column(:position, index + 1)
      end
    end
    puts "Positions updated successfully!"
  end
end
