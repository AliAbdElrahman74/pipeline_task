class AddIndexesToCompaniesColumns < ActiveRecord::Migration[7.0]
  def change
    add_index :companies, :name
    add_index :companies, :industry
    add_index :companies, :employee_count
  end
end
