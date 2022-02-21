class CreateSubsidyKeywords < ActiveRecord::Migration[6.1]
  def change
    create_table :subsidy_keywords do |t|
      t.references :subsidy, null: false, foreign_key: true
      t.references :keyword
      t.timestamps
      t.index [:subsidy_id, :keyword_id], unique: true
    end
  end
end
