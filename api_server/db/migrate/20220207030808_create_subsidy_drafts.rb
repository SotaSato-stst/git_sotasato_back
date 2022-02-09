class CreateSubsidyDrafts < ActiveRecord::Migration[6.1]
  def change
    create_table :subsidy_drafts do |t|
      t.string :title, null: false
      t.text :url, null: false
      t.string :source_url_domain, null: false
      t.references :ministry
      t.references :prefecture
      t.references :city
      t.string :supplier_type
      t.boolean :archived, null: false, default: false
      t.timestamps
    end
  end
end
