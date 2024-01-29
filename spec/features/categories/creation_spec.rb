require 'rails_helper'

RSpec.feature 'Category creation', type: :feature do
  before do
    user = create(:user, :confirmed)
    login_as(user, scope: :user)
  end

  scenario 'User creates a new category' do
    visit new_category_path
    fill_in 'Name', with: 'New Category'
    click_button 'Create'
    expect(page).to have_content('Category was successfully created')
    expect(page).to have_content('New Category')
  end
end