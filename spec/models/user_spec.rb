require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:categories).dependent(:destroy) }
    it { should have_many(:periods).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:locale) }
    it { should validate_inclusion_of(:locale).in_array(I18n.available_locales.map(&:to_s)) }
  end
end
