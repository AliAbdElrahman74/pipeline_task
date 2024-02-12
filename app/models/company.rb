class Company < ApplicationRecord
  has_many :deals

  scope :filter_by_industry, -> (industry) { where("companies.industry like ?", "#{industry}%") }
  scope :filter_by_min_employee_count, -> (count) { where("companies.employee_count >= ?", count)}
  scope :filter_by_name, -> (name) { where("companies.name like ?", "#{name}%")}
  scope :filter_by_min_deal_amount, -> (amount) { joins(:deals)
    .group('companies.id')
    .having('SUM(deals.amount) > ?', amount.to_i)}
end
