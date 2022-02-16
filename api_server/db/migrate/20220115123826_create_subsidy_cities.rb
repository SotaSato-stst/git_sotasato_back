class CreateSubsidyCities < ActiveRecord::Migration[6.1]
  def change
    create_table :subsidy_cities do |t|
        t.references :subsidy, null: false, foreign_key: true
        t.references :city, null: false, foreign_key: true
        t.timestamps
        t.index [:subsidy_id, :city_id], unique: true
    end
  end
end
