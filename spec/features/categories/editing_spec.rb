require 'rails_helper'

RSpec.feature 'Category editing', type: :feature do
  let!(:user) { FactoryBot.create(:user, :confirmed) }
  let!(:category) { FactoryBot.create(:category, user: user) }

  before do
    login_as(user, scope: :user)
  end

  scenario 'User edits a category' do
    visit edit_category_path(category)
    fill_in 'Name', with: 'Updated Category Name'
    click_button 'Update'
    expect(page).to have_content('Category was successfully updated')
    expect(page).to have_content('Updated Category Name')
  end
end
