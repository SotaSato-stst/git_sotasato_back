class AddIndexes2ToSubsidy < ActiveRecord::Migration[6.1]
  def change
    add_index :subsidies, :publishing_code
  end
end
