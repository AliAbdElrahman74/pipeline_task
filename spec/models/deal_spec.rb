# spec/models/deal_spec.rb
require 'rails_helper'

RSpec.describe Deal, type: :model do
  describe 'associations' do
    it { should belong_to(:company) }
  end
end
