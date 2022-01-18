class CreateSubsidyPrefectures < ActiveRecord::Migration[6.1]
  def change
    create_table :subsidy_prefectures do |t|
        t.references :subsidy, null: false
        t.references :prefecture, null: false
        t.timestamps
        t.index [:subsidy_id, :prefecture_id], unique: true
    end
  end
end
