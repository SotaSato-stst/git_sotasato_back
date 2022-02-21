class RemovePropertyFromSubsidies < ActiveRecord::Migration[6.1]
  def change
    remove_column :subsidies, :total_employee, :integer
    remove_column :subsidies, :capital, :integer
  end
end
