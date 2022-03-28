class CreateUserProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :user_profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.date :birthday, null: false
      t.string :gender, null: false

      t.timestamps
    end
  end
end
