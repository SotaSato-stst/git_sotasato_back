class AddPropertiesToSubsidies < ActiveRecord::Migration[6.1]
  def change
    add_column :subsidies, :years_of_establishment, :integer
    add_column :subsidies, :annual_sales_max, :bigint
    add_column :subsidies, :annual_sales_min, :bigint
  end
end