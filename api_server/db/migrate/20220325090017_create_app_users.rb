class CreateAppUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :app_users do |t|
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.date :birthday, null: false
      t.string :gender, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :firebase_uid, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
