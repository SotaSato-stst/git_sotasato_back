class CreateSubsidies < ActiveRecord::Migration[6.1]
  def change
    create_table :subsidies do |t|
      t.string :title, null: false
      t.text :url, null: false, index: {unique: true, length: 256}

      t.timestamps
    end

    create_table :subsidy_ministries do |t|
      t.references :subsidy, null: false
      t.references :ministry, null: false

      t.timestamps
      t.index [:subsidy_id, :ministry_id], unique: true
    end

    create_table :subsidy_prefectures do |t|
      t.references :subsidy, null: false
      t.references :prefecture, null: false

      t.timestamps
      t.index [:subsidy_id, :prefecture_id], unique: true
    end

    create_table :subsidy_cities do |t|
      t.references :subsidy, null: false
      t.references :city, null: false

      t.timestamps
      t.index [:subsidy_id, :city_id], unique: true
    end
  end
end
