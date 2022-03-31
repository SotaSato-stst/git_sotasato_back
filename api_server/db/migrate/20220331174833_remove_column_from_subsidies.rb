class RemoveColumnFromSubsidies < ActiveRecord::Migration[6.1]
  def change
    remove_column :subsidies, :target_detail
  end
end
