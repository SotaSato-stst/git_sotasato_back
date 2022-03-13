class DivideColumnsOnUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :last_name, :string, null: false, default: ''
    add_column :users, :first_name, :string, null: false, default: ''
    User.all.each do |user|
      user.last_name = user.display_name
      user.first_name = user.display_name
      user.save
    end
    remove_column :users, :display_name
  end
end
