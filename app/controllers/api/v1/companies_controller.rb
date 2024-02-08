class Api::V1::CompaniesController < ApplicationController
  def index
    companies = Company.where(nil)
    companies = companies.filter_by_industry(params[:industry]) if params[:industry].present?
    companies = companies.filter_by_name(params[:name]) if params[:name].present?
    companies = companies.filter_by_min_employee_count(params[:min_employee_count]) if params[:min_employee_count].present?
    companies = companies.filter_by_min_deal_amount(params[:minimum_deal_amount]) if params[:minimum_deal_amount].present?
    companies = companies.page(params[:page]).order(:name)
    companies = companies.select('SUM(deals.amount) as deals_amount, companies.*')
                         .joins('LEFT OUTER JOIN deals ON companies.id = deals.company_id')
                         .group('companies.id')

    total_pages = companies.total_pages

    render json: {
      total_pages: total_pages,
      companies: companies.as_json,
      current_page: params[:page].to_i + 1
      }
  end
end
