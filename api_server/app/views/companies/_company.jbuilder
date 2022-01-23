json.call(company, :id, :name, :prefecture_id, :city_id, :adress, :capital, :total_employee, :business_scale)

json.prefecture do
  json.partial! 'prefectures/prefecture', prefecture: company.prefecture
end
json.city do
  json.partial! 'cities/city', city: company.city
end
