json.call(@current_user, :display_name, :email, :account_role)

json.company do
  json.call(
    @company,
    :name,
    :organization_type,
    :prefecture_id,
    :city_id,
    :adress,
    :capital,
    :total_employee,
    :founding_date,
    :annual_sales
  )
  json.prefecture_name @company.prefecture.name
  json.city_name @company.city.name
  json.business_categories @company.company_business_categories.map(&:business_category)
end
