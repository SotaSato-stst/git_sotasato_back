class CreateFamilyMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :family_members do |t|
      t.references :family, null: false, foreign_key: true
      t.date :birthday, null: false
      t.string :relationship, null: false

      t.timestamps
    end
  end
end
