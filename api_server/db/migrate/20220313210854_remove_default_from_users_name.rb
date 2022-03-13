class RemoveDefaultFromUsersName < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :last_name, nil
    change_column_default :users, :first_name, nil
  end
end
