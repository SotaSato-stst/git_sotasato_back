class CreateSuppliers < ActiveRecord::Migration[6.1]
  def change
    create_table :ministries do |t|
      t.string :name, null: false, index: {unique: true}
      t.string :logo_url, null: false, default: ''
      t.string :url_domain, null: false, default: ''

      t.timestamps
    end

    create_table :prefectures do |t|
      t.string :name, null: false, index: {unique: true}
      t.string :logo_url, null: false, default: ''
      t.string :url_domain, null: false, default: ''

      t.timestamps
    end

    create_table :cities do |t|
      t.string :name, null: false
      t.string :logo_url, null: false, default: ''
      t.string :url_domain, null: false, default: ''
      t.references :prefecture, null: false

      t.timestamps
    end
  end
end
