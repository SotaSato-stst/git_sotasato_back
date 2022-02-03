class CreateUserFavoriteSubsidies < ActiveRecord::Migration[6.1]
  def change
    create_table :user_favorite_subsidies do |t|

      t.references :user, null: false
      t.references :subsidy, null: false
      t.timestamps
    end
    add_index  :user_favorite_subsidies, [:user_id, :subsidy_id], unique: true
  end
end