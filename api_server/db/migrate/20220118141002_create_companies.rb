class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.references :prefecture, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true
      t.string :adress
      t.integer :capital
      t.integer :total_employee 
      t.string :business_scale
      t.timestamps
    end
  end
end
