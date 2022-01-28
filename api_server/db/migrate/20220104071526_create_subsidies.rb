class CreateSubsidies < ActiveRecord::Migration[6.1]
  def change
    create_table :subsidies do |t|
      t.string :title, null: false
      t.text :url, null: false, index: {unique: true, length: 256}
      t.date :start_from,   null: false
      t.date :end_to
      t.string :publishing_code, null:false
      t.integer :price_max
      t.string :support_ratio_min
      t.string :support_ratio_max
      t.integer :level
      t.text :detail, null:false
      t.text :target_detail, null:false
      t.string :subsidy_category
      t.string :supplier_type
      t.timestamps
    end
  end
end