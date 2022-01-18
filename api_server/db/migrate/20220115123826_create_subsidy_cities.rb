class CreateSubsidyCities < ActiveRecord::Migration[6.1]
  def change
    create_table :subsidy_cities do |t|
        t.references :subsidy, null: false
        t.references :city, null: false
        t.timestamps
        t.index [:subsidy_id, :city_id], unique: true
    end
  end
end
