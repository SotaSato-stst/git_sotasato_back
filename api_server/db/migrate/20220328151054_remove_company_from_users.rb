class RemoveCompanyFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_reference :users, :company
  end
end
