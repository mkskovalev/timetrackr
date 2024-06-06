require 'rails_helper'

RSpec.feature "TrackerPath", type: :feature do
  let(:user) { create(:user, :confirmed) }
  
  before do
    login_as(user, scope: :user)
    I18n.locale = :en
  end

  scenario "User visits the tracker path page and sees the headings" do
    visit tracker_path(locale: I18n.locale)

    expect(page).to have_selector("h1", text: "Tracker")
    expect(page).to have_selector("h2", text: "Categories")
  end

  context "when there are categories" do
    before do
      @category1 = create(:category, user: user)
      @category2 = create(:category, user: user)
      visit tracker_path(locale: I18n.locale)
    end

    scenario "User sees the categories on the tracker path page" do
      expect(page).to have_content(@category1.name)
      expect(page).to have_content(@category2.name)
    end
  end

  context "when there are no categories" do
    before do
      visit tracker_path(locale: I18n.locale)
    end

    scenario "User sees a message indicating there are no categories" do
      expect(page).to have_content("Create a new category")
    end
  end
end
