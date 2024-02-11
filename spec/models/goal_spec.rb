require 'rails_helper'

RSpec.describe Goal, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
  end

  describe 'validations' do
    it { should validate_presence_of(:duration) }
    it { should validate_numericality_of(:duration).is_greater_than(0) }
    it { should validate_presence_of(:schedule) }
    it { should validate_inclusion_of(:schedule).in_array(Goal::SCHEDULES) }
  end

  describe 'Uniqueness validations' do
    let(:user) { FactoryBot.create(:user, :confirmed) }
    subject { FactoryBot.create(:goal, user: user) }

    it 'validates uniqueness of category_id scoped to user_id with a custom message' do
      should validate_uniqueness_of(:category_id).scoped_to(:user_id).with_message("You can only have one goal per category")
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:goal)).to be_valid
    end
  end
end
