require 'rails_helper'

RSpec.feature 'Create category with specific parent eligibility', type: :feature do
  given(:user) { FactoryBot.create(:user, :confirmed) }
  given!(:eligible_parent_category) { FactoryBot.create(:category, user: user) }
  given!(:ineligible_parent_category) { FactoryBot.create(:category, user: user) }
  given!(:period) { FactoryBot.create(:period, category: ineligible_parent_category, user: user) }

  background do
    login_as(user, scope: :user)
    visit new_category_path
  end

  scenario 'User should see only eligible parent categories in the dropdown' do
    expect(page).to have_select('Parent category', with_options: [eligible_parent_category.name])
    expect(page).to_not have_select('Parent category', with_options: [ineligible_parent_category.name])
  end
end
