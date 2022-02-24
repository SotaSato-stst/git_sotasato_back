class ChangePropertiesToSubsidies < ActiveRecord::Migration[6.1]
  def change
    change_column :subsidies, :price_max, :bigint
    change_column :subsidies, :capital_max, :bigint
  end
end
