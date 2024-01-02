require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it { should belong_to(:parent).class_name('Category').optional }
    it { should have_many(:periods) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end
end
