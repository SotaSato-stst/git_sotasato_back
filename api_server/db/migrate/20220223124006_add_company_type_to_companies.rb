class AddCompanyTypeToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :organization_type, :string, null: false, default: ''
  end
end
