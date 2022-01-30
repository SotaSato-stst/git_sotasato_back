class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :firebase_uid, null: false, index: {unique: true}
      t.references :company, null: false
      t.string :email, null: false, default: ""
      t.string :display_name, null: false, default: ""
      t.timestamps
    end
  end
end
