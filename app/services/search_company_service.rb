class SearchCompanyService

  def initialize(params)
    @params = params
  end

  def call
    result = {
      companies: [],
      total_pages: 0,
      errors: @errors
    }
    validator_result = Validators::CompanySearch.new(@params)
    if validator_result.invalid?
      result[:errors] = validator_result.errors.full_messages
    else
      search_company_result = search_company
      result[:companies] = search_company_result[:companies]
      result[:total_pages] = search_company_result[:total_pages]
    end

    result
  end

  private

  def search_company
    page = @params[:page] || 1
    companies = Company.where(nil)
    companies = companies.filter_by_industry(@params[:industry]) if @params[:industry].present?
    companies = companies.filter_by_name(@params[:name]) if @params[:name].present?
    companies = companies.filter_by_min_employee_count(@params[:min_employee_count]) if @params[:min_employee_count].present?
    companies = companies.filter_by_min_deal_amount(@params[:minimum_deal_amount]) if @params[:minimum_deal_amount].present?
    companies = companies.page(page).order(:name)
    companies = companies.select('SUM(deals.amount) as deals_amount, companies.*')
                         .joins('LEFT OUTER JOIN deals ON companies.id = deals.company_id')
                         .group('companies.id')

    total_pages = companies.total_pages

    return {
      companies: companies,
      total_pages: total_pages
    }
  end
end

