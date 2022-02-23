class AddIndexesToSubsidy < ActiveRecord::Migration[6.1]
  def change
    add_index :subsidies, :price_max
    add_index :subsidies, :ranking_score
  end
end
