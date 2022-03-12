class CreateUserEmailUnsubscribes < ActiveRecord::Migration[6.1]
  def change
    create_table :user_email_unsubscribes do |t|
      t.references :user, null: false
      t.string :email_category, null: false
      t.timestamps
    end
  end
end
