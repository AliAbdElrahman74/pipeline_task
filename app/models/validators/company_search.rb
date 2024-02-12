module Validators
  class CompanySearch
    include ActiveModel::Validations

    def initialize(data = {})
      @company_search_params = data
    end

    def read_attribute_for_validation(key)
      value = @company_search_params&.fetch(key, nil)

      return value.to_s
    end

    validates :name, format: { with: /\A[a-zA-Z0-9]+\z/, message: "must contain only letters and numbers" }, allow_blank: true
    validates :industry, format: { with: /\A[a-zA-Z0-9]+\z/, message: "must contain only letters and numbers" }, allow_blank: true
    validates :min_employee_count, :numericality => { :greater_than_or_equal_to => 0, :message => "only allows positive numbers" }, allow_blank: true
    validates :minimum_deal_amount, :numericality => { :greater_than_or_equal_to => 0, :message => "only allows positive numbers" }, allow_blank: true
  end
end
  