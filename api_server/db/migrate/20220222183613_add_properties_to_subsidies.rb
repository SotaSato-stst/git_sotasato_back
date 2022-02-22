class AddPropertiesToSubsidies < ActiveRecord::Migration[6.1]
  def change
    add_column :subsidies, :founding_date_max, :date
    add_column :subsidies, :founding_date_min, :date
    add_column :subsidies, :annual_sales_max, :bigint
    add_column :subsidies, :annual_sales_min, :bigint
  end
end