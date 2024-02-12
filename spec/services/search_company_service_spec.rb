# spec/controllers/api/v1/companies_controller_spec.rb
require 'rails_helper'

RSpec.describe SearchCompanyService, type: :service do
  describe '#call' do
    let!(:company1) { create(:company, name: 'Company 1', industry: 'Technology') }
    let!(:company2) { create(:company, name: 'Company 2', industry: 'Finance') }
    let!(:company3) { create(:company, name: 'Company 3', employee_count: 100) }
    let!(:deal1) { create(:deal, company: company1, amount: 500) }
    let!(:deal2) { create(:deal, company: company1, amount: 1000) }

    context 'with no filters' do
      it 'returns a list of all companies' do
        result = described_class.new({}).call
        expect(result[:companies].length).to eq(3)
      end
    end

    context 'with industry filter' do
      it 'returns companies filtered by industry' do
        params = {
          industry: "tech",
        }
        result = described_class.new(params).call
        expect(result[:companies].length).to eq(1)
        expect(result[:companies].first['name']).to eq('Company 1')
      end
    end

    context 'with min_employee_count filter' do
      it 'returns companies filtered by min_employee_count' do
        params = {
          min_employee_count: 100,
        }
        result = described_class.new(params).call
        expect(result[:companies].length).to eq(1)
        expect(result[:companies].first['name']).to eq('Company 3')
      end
    end

    context 'with minimum_deal_amount filter' do
      it 'returns companies filtered by minimum_deal_amount' do
        params = {
          minimum_deal_amount: 1000,
        }
        result = described_class.new(params).call
        expect(result[:companies].length).to eq(1)
        expect(result[:companies].first['name']).to eq('Company 1')
      end
    end

    context 'with invalid filters' do
      it 'returns errors' do
        params =  { minimum_deal_amount: -1, min_employee_count: -1, name: "@", industry: "@" }
        result = described_class.new(params).call
        expect(result[:errors]).to eq ["Name must contain only letters and numbers",
          "Industry must contain only letters and numbers",
          "Min employee count only allows positive numbers",
          "Minimum deal amount only allows positive numbers"]
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
