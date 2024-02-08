class Api::V1::CompaniesController < ApplicationController
  def index
    page = filter_params[:page] || 1
    companies = Company.where(nil)
    companies = companies.filter_by_industry(filter_params[:industry]) if filter_params[:industry].present?
    companies = companies.filter_by_name(filter_params[:name]) if filter_params[:name].present?
    companies = companies.filter_by_min_employee_count(filter_params[:min_employee_count]) if filter_params[:min_employee_count].present?
    companies = companies.filter_by_min_deal_amount(filter_params[:minimum_deal_amount]) if filter_params[:minimum_deal_amount].present?
    companies = companies.page(page).order(:name)
    companies = companies.select('SUM(deals.amount) as deals_amount, companies.*')
                         .joins('LEFT OUTER JOIN deals ON companies.id = deals.company_id')
                         .group('companies.id')

    total_pages = companies.total_pages

    render json: {
      total_pages: total_pages,
      companies: companies.as_json,
      }
  end


  private

  def filter_params
    params.permit(:name, :page, :industry, :minimum_deal_amount, :min_employee_count)
  end
end
