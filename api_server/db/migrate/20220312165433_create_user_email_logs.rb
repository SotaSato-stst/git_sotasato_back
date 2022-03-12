class CreateUserEmailLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :user_email_logs do |t|
      t.references :user, null: false
      t.string :email_category, null: false
      t.date :sent_date, null: false, index: true
      t.timestamps
    end
  end
end
