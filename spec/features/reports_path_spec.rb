require 'rails_helper'

RSpec.feature "ReportsPath", type: :feature do
  let(:user) { create(:user, :confirmed) }
  
  before do
    login_as(user, scope: :user)
    I18n.locale = :en
  end

  scenario "User visits the reports path page and sees the headings" do
    visit reports_path(locale: I18n.locale)

    expect(page).to have_selector("h1", text: "Reports")
  end

  context "when there are reports" do
    before do
      @category = create(:category, user: user)
      @report = create(:report, user: user, category: @category)
      visit reports_path(locale: I18n.locale)
    end

    scenario "User sees the reports on the reports path page" do
      expect(page).to have_content(@report.category.name)
      expect(page).to have_content(@report.created_at.strftime('%d.%m.%Y %H:%M:%S'))
    end
  end

  context "when there are no reports" do
    before do
      visit reports_path(locale: I18n.locale)
    end

    scenario "User sees an empty table for reports" do
      within('table#reports_list') do
      expect(page).to have_selector('tr', count: 1) # only title
    end
    end
  end
end
