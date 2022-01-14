class AddSubsidies < ActiveRecord::Migration[6.1]
  def change
    add_column :subsidies, :start_from, :date,  null: false
    add_column :subsidies, :end_to, :date
  end
end
