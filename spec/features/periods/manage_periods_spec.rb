require 'rails_helper'

RSpec.feature 'Managing periods in category', type: :feature do
  let!(:user) { FactoryBot.create(:user, :confirmed) }
  let!(:category) { FactoryBot.create(:category, user: user) }
  
  before do
    login_as(user, scope: :user)
    visit timer_path
  end

  scenario 'User starts a new period for a category' do
    expect(page).to have_selector("#category-start-#{category.id}")

    find("#category-start-#{category.id}").click

    expect(page).to have_no_selector("#category-start-#{category.id}")
    expect(page).to have_selector("#category-stop-#{category.id}")

    new_period = category.periods.order(created_at: :desc).first
    expect(new_period.end).to be_nil
  end

  scenario 'User stops an ongoing period for a category' do
    expect(page).to have_selector("#category-start-#{category.id}")

    find("#category-start-#{category.id}").click

    expect(page).to have_no_selector("#category-start-#{category.id}")
    expect(page).to have_selector("#category-stop-#{category.id}")

    find("#category-stop-#{category.id}").click

    expect(page).to have_selector("#category-start-#{category.id}")
    expect(page).to have_no_selector("#category-stop-#{category.id}")

    finished_period = category.periods.order(created_at: :desc).first
    expect(finished_period.end).not_to be_nil
  end
end
