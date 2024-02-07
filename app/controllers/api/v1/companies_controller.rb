class Api::V1::CompaniesController < ApplicationController
  def index
    companies = Company.includes(:deals).page(params[:page]).fast_page
    total_pages = Company.page(params[:page]).fast_page.total_pages

    render json: {
      total_pages: total_pages,
      companies: companies.as_json(include: :deals),
      current_page: params[:page].to_i + 1
      }
  end
end
