class AddPropertyToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :founding_date, :date
    add_column :companies, :annual_sales, :bigint
  end
end
