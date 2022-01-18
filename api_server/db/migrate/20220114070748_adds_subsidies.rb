class AddsSubsidies < ActiveRecord::Migration[6.1]
  def change
    add_column :subsidies, :publishing_code, :string, null:false
    add_column :subsidies, :price_max, :integer
    add_column :subsidies, :support_ratio_min, :string
    add_column :subsidies, :support_ratio_max, :string
    add_column :subsidies, :level, :integer
    add_column :subsidies, :detail, :text, null:false
    add_column :subsidies, :target_detail, :text, null:false
  end
end
