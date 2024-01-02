require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:categories).dependent(:destroy) }
    it { should have_many(:periods).dependent(:destroy) }
  end
end
