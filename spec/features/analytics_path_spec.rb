require 'rails_helper'

RSpec.feature "AnalyticsPath", type: :feature do
  let(:user) { create(:user, :confirmed) }
  
  before do
    login_as(user, scope: :user)
    I18n.locale = :en
  end

  scenario "User visits the analytics path page and sees the headings" do
    visit analytics_path(locale: I18n.locale)

    expect(page).to have_selector("h1", text: "Analytics")
  end
end
