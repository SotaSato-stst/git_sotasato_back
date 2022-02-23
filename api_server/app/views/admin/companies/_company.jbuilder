json.call(
  company,
  :id,
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

json.prefecture do
  json.partial! 'prefectures/prefecture', prefecture: company.prefecture
end
json.city do
  json.partial! 'cities/city', city: company.city
end
json.business_categories company.business_categories.map do |business_category|
  json.merge! business_category
end
