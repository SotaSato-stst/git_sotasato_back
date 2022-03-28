json.call(
  benefit,
  :publishing_code,
  :id,
  :title,
  :url,
  :target_detail,
  :price_detail,
  :application_detail,
  :end_date,
  :for_welfare,
  :for_elderly_care,
  :for_widow,
  :for_disabled,
  :age_from,
  :age_to,
  :household_income_from,
  :household_income_to
)

json.prefecture do
  json.partial! 'prefectures/prefecture', prefecture: benefit.prefecture
end
json.city do
  json.partial! 'cities/city', city: benefit.city
end
