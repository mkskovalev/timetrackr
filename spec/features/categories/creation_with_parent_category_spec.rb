require 'rails_helper'

RSpec.feature 'Create category with parent category', type: :feature do
  given(:user) { FactoryBot.create(:user, :confirmed) }
  given!(:parent_category) { FactoryBot.create(:category, user_id: user.id) }

  background do
    login_as(user, scope: :user)
    visit new_category_path
  end

  scenario 'User creates a category with a parent category' do
    fill_in 'Name', with: 'New Subcategory'
    select parent_category.name, from: 'Parent category'
    click_button 'Create'

    expect(page).to have_content('Category was successfully created')
    expect(page).to have_content('New Subcategory')
    # проверяем, что созданная категория имеет родителя
    expect(Category.find_by(name: 'New Subcategory').parent).to eq(parent_category)
  end
end
