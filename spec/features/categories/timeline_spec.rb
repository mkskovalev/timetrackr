RSpec.describe 'Timeline', type: :feature do
  let!(:user) { create(:user, :confirmed) }
  let!(:category) { create(:category, user: user) }

  scenario 'all periods within the day are displayed on the timeline' do
    current_day = Time.now.to_date

    completed_period_start = current_day.beginning_of_day + 3.hours
    completed_period_end = current_day.beginning_of_day + 5.hours
  
    create(:period, category: category, user: user, start: completed_period_start, end: completed_period_end)
    create(:period, category: category, user: user, start: completed_period_end + 1.hour, end: nil)
  
    login_as(user, scope: :user)
    visit tracker_path
  
    expect(page).to have_selector('.completed-period', count: 1)
    expect(page).to have_selector('[data-timeline-target="currentPeriod"]', count: 1)
  end

  scenario 'only periods within the current day are displayed on the timeline' do
    current_day = Time.now.to_date

    create(:period, category: category, user: user, start: current_day.yesterday.beginning_of_day, end: current_day.yesterday.end_of_day - 1.second)
    create(:period, category: category, user: user, start: current_day.beginning_of_day + 1.hour, end: current_day.beginning_of_day + 3.hours)

    login_as(user, scope: :user)
    visit tracker_path

    expect(page).to have_selector('.completed-period', count: 1)
    expect(page).not_to have_selector('[data-timeline-target="currentPeriod"]')
  end

  scenario 'periods not within the current day are not displayed on the timeline' do
    current_day = Time.now.to_date

    create(:period, category: category, user: user, start: current_day.yesterday.beginning_of_day, end: current_day.yesterday.end_of_day)

    login_as(user, scope: :user)
    visit tracker_path

    expect(page).not_to have_selector('.completed-period')
    expect(page).not_to have_selector('[data-timeline-target="currentPeriod"]')
  end
  
  scenario 'periods that started the previous day and continue to the current day are displayed on the timeline' do
    create(:period, category: category, user: user, start: Time.now.to_date.yesterday.midday, end: nil)

    login_as(user, scope: :user)
    visit tracker_path

    expect(page).not_to have_selector('.completed-period')
    expect(page).to have_selector('[data-timeline-target="currentPeriod"]')
  end
end
