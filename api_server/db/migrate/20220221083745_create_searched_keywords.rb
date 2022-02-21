class CreateSearchedKeywords < ActiveRecord::Migration[6.1]
  def change
    create_table :searched_keywords do |t|
      t.references :user, null: false, foreign_key: true
      t.references :keyword
      t.string :content
      t.integer :hit_count, null: false
      t.timestamps
    end
  end
end
