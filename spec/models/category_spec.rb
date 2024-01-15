require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:parent).class_name('Category').optional }
    it { should have_many(:childrens).class_name('Category').with_foreign_key('parent_id').dependent(:destroy) }
    it { should have_many(:periods).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end
end
