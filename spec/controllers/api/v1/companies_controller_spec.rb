# spec/controllers/api/v1/companies_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::CompaniesController, type: :controller do
  describe 'GET #index' do
    let!(:company1) { create(:company, name: 'Company 1', industry: 'Technology') }
    let!(:company2) { create(:company, name: 'Company 2', industry: 'Finance') }
    let!(:company3) { create(:company, name: 'Company 3', employee_count: 100) }
    let!(:deal1) { create(:deal, company: company1, amount: 500) }
    let!(:deal2) { create(:deal, company: company1, amount: 1000) }

    context 'with no filters' do
      it 'returns a list of all companies' do
        get :index
        expect(response).to have_http_status(:success)
        expect(json_response['companies'].length).to eq(3)
      end
    end

    context 'with industry filter' do
      it 'returns companies filtered by industry' do
        get :index, params: { industry: 'Technology' }
        expect(response).to have_http_status(:success)
        expect(json_response['companies'].length).to eq(1)
        expect(json_response['companies'].first['name']).to eq('Company 1')
      end
    end

    context 'with min_employee_count filter' do
      it 'returns companies filtered by min_employee_count' do
        get :index, params: { min_employee_count: 100 }
        expect(response).to have_http_status(:success)
        expect(json_response['companies'].length).to eq(1)
        expect(json_response['companies'].first['name']).to eq('Company 3')
      end
    end

    context 'with minimum_deal_amount filter' do
      it 'returns companies filtered by minimum_deal_amount' do
        get :index, params: { minimum_deal_amount: 1000 }
        expect(response).to have_http_status(:success)
        expect(json_response['companies'].length).to eq(1)
        expect(json_response['companies'].first['name']).to eq('Company 1')
      end
    end

    context 'with pagination' do
      it 'returns paginated results' do
        get :index, params: { page: 1 }
        expect(response).to have_http_status(:success)
        expect(json_response['total_pages']).to eq(1)
      end
    end

    context 'when ActiveRecord::RecordNotFound is raised' do
      before do
        allow(Company).to receive(:where).and_raise(ActiveRecord::RecordNotFound)
      end

      it 'renders a 404 error response' do
        get :index, params: { page: 1 }

        expect(response.status).to eq(404)
        expect(json_response["error"]).to eq("Record not found")
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
