class CreateSubsidies < ActiveRecord::Migration[6.1]
  def change
    create_table :subsidies do |t|
      t.string :title, null: false
      t.text :url, null: false

      t.timestamps
    end
  end
end
