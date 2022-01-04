class CreateSuppliers < ActiveRecord::Migration[6.1]
  def change
    create_table :suppliers do |t|
      t.string :name, null: false, index: {unique: true}
      t.string :organization_type, null: false
      t.string :logo_url, null: false, default: ''

      t.timestamps
    end
  end
end
