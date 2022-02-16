class CreateCompanyBusinessCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :company_business_categories do |t|
      t.references :company, null: false, foreign_key: true
      t.string :business_category, null: false
      t.timestamps

      t.index [:company_id, :business_category], unique: true, name: :index_unique_company_business_categories
    end
  end
end
