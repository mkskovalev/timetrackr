require 'rails_helper'

RSpec.feature "PeriodsPath", type: :feature do
  let(:user) { create(:user, :confirmed) }
  
  before do
    login_as(user, scope: :user)
    I18n.locale = :en
  end

  scenario "User visits the periods path page and sees the headings" do
    visit periods_path(locale: I18n.locale)

    expect(page).to have_selector("h1", text: "Periods")
  end

  context "when there are periods" do
    before do
      @category = create(:category, user: user)
      @period = create(:period, user: user, category: @category)
      visit periods_path(locale: I18n.locale)
    end

    scenario "User sees the periods on the periods path page" do
      expect(page).to have_content(@period.category.name)
      expect(page).to have_content('11:52 - 11:54')
    end
  end

  context "when there are no periods" do
    before do
      visit periods_path(locale: I18n.locale)
    end

    scenario "User sees an empty table for periods" do
      within('table#periods_list') do
      expect(page).to have_selector('tr', count: 1) # only title
    end
    end
  end
end
