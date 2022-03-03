class AddCatchcopyToSubsidies < ActiveRecord::Migration[6.1]
  def change
    add_column :subsidies, :catch_copy, :string
  end
end
