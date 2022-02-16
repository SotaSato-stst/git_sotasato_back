class CreateSubsidyMinistries < ActiveRecord::Migration[6.1]
  def change
    create_table :subsidy_ministries do |t|
        t.references :subsidy, null: false, foreign_key: true
        t.references :ministry, null: false, foreign_key: true
        t.timestamps
        t.index [:subsidy_id, :ministry_id], unique: true
    end
  end
end

