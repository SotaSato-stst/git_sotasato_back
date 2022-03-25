class CreateBenefits < ActiveRecord::Migration[6.1]
  def change
    create_table :benefits do |t|
      t.string :title, null: false
      t.text :url, null: false, index: {unique: true, length: 256}
      t.references :prefecture, foreign_key: true
      t.references :city, foreign_key: true
      t.text :target_detail, null: false
      t.text :price_detail, null: false
      t.text :application_detail, null: false
      t.date :end_date
      t.boolean :for_welfare, null: false, default: false
      t.boolean :for_elderly_care, null: false, default: false
      t.boolean :for_widow, null: false, default: false
      t.boolean :for_disabled, null: false, default: false
      t.integer :age_from
      t.integer :age_to
      t.integer :household_income_from
      t.integer :household_income_to

      t.timestamps
    end
  end
end
