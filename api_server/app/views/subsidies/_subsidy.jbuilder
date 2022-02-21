json.call(
  subsidy,
  :id,
  :title,
  :url,
  :start_from,
  :end_to,
  :publishing_code,
  :price_max,
  :support_ratio_min,
  :support_ratio_max,
  :level,
  :detail,
  :target_detail,
  :subsidy_category,
  :supplier_type,
  :business_categories,
  :ranking_score,
  :capital_max,
  :capital_min,
  :total_employee_max,
  :total_employee_min,
)

json.ministry do
  json.partial! 'ministries/ministry', ministry: subsidy.ministry
end
json.prefecture do
  json.partial! 'prefectures/prefecture', prefecture: subsidy.prefecture
end
json.city do
  json.partial! 'cities/city', city: subsidy.city
end
json.business_categories subsidy.business_categories.map do |business_category|
  json.merge! business_category
end
json.favorite @current_user_favorite_ids.to_a.include?(subsidy.id)
