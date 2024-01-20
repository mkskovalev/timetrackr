require 'rails_helper'

RSpec.feature 'Category deletion', type: :feature do
  let!(:user) { FactoryBot.create(:user, :confirmed) }
  let!(:category) { FactoryBot.create(:category, user: user) }

  before do
    login_as(user, scope: :user)
  end

  scenario 'User deletes a category' do
    visit timer_path
    within "#category-card-#{category.id}" do
      click_button 'Delete'
    end
    expect(page).to have_content('Category was successfully deleted')
    expect(page).not_to have_content(category.name)
  end
end
