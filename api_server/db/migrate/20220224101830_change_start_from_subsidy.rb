class ChangeStartFromSubsidy < ActiveRecord::Migration[6.1]
  def change
    change_column :subsidies, :start_from, :date, null: true
  end
end
