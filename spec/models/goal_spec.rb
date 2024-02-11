require 'rails_helper'

RSpec.describe Goal, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:category) }

  it { should validate_presence_of(:duration) }
  it { should validate_numericality_of(:duration).is_greater_than(0) }
  it { should validate_presence_of(:schedule) }
  it { should validate_inclusion_of(:schedule).in_array(Goal::SCHEDULES) }

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:goal)).to be_valid
    end
  end
end
