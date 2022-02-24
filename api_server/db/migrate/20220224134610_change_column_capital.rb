class ChangeColumnCapital < ActiveRecord::Migration[6.1]
  def change
    change_column :subsidies, :capital_min, :bigint
    change_column :companies, :capital, :bigint
  end
end
