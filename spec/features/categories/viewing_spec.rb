require 'rails_helper'

RSpec.feature 'Category Viewing', type: :feature do
  scenario 'Guest tries to view categories' do
    visit timer_path
    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  scenario 'Registered user views categories' do
    user = FactoryBot.create(:user, :confirmed)
    login_as(user, scope: :user)
    visit timer_path
    expect(page).to have_content('Categories')
  end
end