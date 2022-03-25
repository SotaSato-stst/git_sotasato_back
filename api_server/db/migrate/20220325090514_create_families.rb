class CreateFamilies < ActiveRecord::Migration[6.1]
  def change
    create_table :families do |t|
      t.references :app_user, null: false, foreign_key: true, index: { unique: true }
      t.references :prefecture, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true
      t.integer :household_income
      t.boolean :on_welfare
      t.boolean :on_elderly_care
      t.boolean :has_widow
      t.boolean :has_disabled

      t.timestamps
    end
  end
end
