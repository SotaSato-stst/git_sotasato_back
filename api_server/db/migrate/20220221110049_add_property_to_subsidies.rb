class AddPropertyToSubsidies < ActiveRecord::Migration[6.1]
  def change
    add_column :subsidies, :total_employee_max, :integer
    add_column :subsidies, :total_employee_min, :integer
    add_column :subsidies, :capital_max, :integer
    add_column :subsidies, :capital_min, :integer
  end
end
