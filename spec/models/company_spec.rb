# spec/models/company_spec.rb
require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'associations' do
    it { should have_many(:deals) }
  end

  describe 'scopes' do
    let!(:company1) { create(:company, name: 'Company 1', industry: 'Technology', employee_count: 100) }
    let!(:company2) { create(:company, name: 'Company 2', industry: 'Finance', employee_count: 200) }
    let!(:deal1) { create(:deal, company: company1, amount: 500) }
    let!(:deal2) { create(:deal, company: company2, amount: 1000) }

    describe '.filter_by_industry' do
      it 'returns companies filtered by industry' do
        puts "*********"
        puts "*********"
        puts "*********"
        puts "*********"
        puts ActiveRecord::Base.connection.current_database
        puts "*********"
        puts "*********"
        puts "*********"
        puts "*********"
        expect(Company.filter_by_industry('Technology')).to eq([company1])
      end
    end

    describe '.filter_by_min_employee_count' do
      it 'returns companies with minimum employee count' do
        expect(Company.filter_by_min_employee_count(150)).to eq([company2])
      end
    end

    describe '.filter_by_name' do
      it 'returns companies filtered by name' do
        expect(Company.filter_by_name('Company')).to eq([company1, company2])
      end
    end

    describe '.filter_by_min_deal_amount' do
      it 'returns companies with minimum deal amount' do
        expect(Company.filter_by_min_deal_amount(800)).to eq([company2])
      end
    end
  end
end
