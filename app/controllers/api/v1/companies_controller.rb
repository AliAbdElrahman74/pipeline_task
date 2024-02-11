class Api::V1::CompaniesController < ApplicationController
  def index
    search_company_result = ::SearchCompanyService.new(filter_params).call

    if search_company_result[:errors].present?
      return handle_errors(search_company_result[:errors], 422)
    end

    render json: {
      total_pages: search_company_result[:total_pages],
      companies: search_company_result[:companies],
      }
  end


  private

  def filter_params
    params.permit(:name, :page, :industry, :minimum_deal_amount, :min_employee_count)
  end
end
