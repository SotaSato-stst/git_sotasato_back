json.call(subsidy, :id, :title, :url, :start_from, :end_to, :publishing_code, :price_max, :support_ratio_min,
          :support_ratio_max, :level, :detail, :target_detail)

json.ministry do
  json.partial! 'ministries/ministry', ministry: subsidy.ministry
end
json.prefecture do
  json.partial! 'prefectures/prefecture', prefecture: subsidy.prefecture
end
json.city do
  json.partial! 'cities/city', city: subsidy.city
end
