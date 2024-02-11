require 'rails_helper'

RSpec.describe Period, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
  end

  describe 'validations' do
    it { should validate_presence_of :start }
  end

  describe 'custom validation no_overlap' do
    let(:user) { FactoryBot.create(:user, :confirmed) }
    let!(:category) { FactoryBot.create(:category, user: user) }
    let!(:existing_period) { FactoryBot.create(:period, user: user, category: category, start: 1.day.ago, end: 1.day.from_now) }

    it 'is not valid if it overlaps with an existing period' do
      overlapping_period = FactoryBot.build(:period, user: user, category: category, start: existing_period.start, end: existing_period.end)
      expect(overlapping_period).not_to be_valid
    end

    it 'is valid if it does not overlap with an existing period' do
      non_overlapping_period = FactoryBot.build(:period, user: user, start: 3.days.from_now, end: 2.days.from_now)
      expect(non_overlapping_period).to be_valid
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:period)).to be_valid
    end
  end
end
