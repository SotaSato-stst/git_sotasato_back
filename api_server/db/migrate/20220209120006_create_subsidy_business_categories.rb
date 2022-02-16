class CreateSubsidyBusinessCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :subsidy_business_categories do |t|
      t.references :subsidy, null: false, foreign_key: true
      t.string :business_category, null: false
      t.timestamps

      t.index [:subsidy_id, :business_category], unique: true, name: :index_unique_subsidy_business_categories
    end
  end
end
