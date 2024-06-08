require 'rails_helper'

RSpec.feature "ProfilePath", type: :feature do
  let(:user) { create(:user, :confirmed) }
  
  before do
    login_as(user, scope: :user)
    I18n.locale = :en
  end

  scenario "User visits the profile path page and sees the headings" do
    visit profile_path(locale: I18n.locale)

    expect(page).to have_selector("h1", text: "Profile")
    expect(page).to have_selector("h2", text: "General settings")
  end
end
