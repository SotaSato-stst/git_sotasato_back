class CreateSubsidyOrganizationTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :subsidy_organization_types do |t|
      t.references :subsidy, null: false, foreign_key: true
      t.string :organization_type, null: false
      t.timestamps
    end
  end
end
