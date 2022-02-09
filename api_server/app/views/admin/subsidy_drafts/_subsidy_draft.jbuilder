json.call(subsidy_draft, :id, :title, :url, :supplier_type)

json.ministry do
  json.partial! 'ministries/ministry', ministry: subsidy_draft.ministry
end
json.prefecture do
  json.partial! 'prefectures/prefecture', prefecture: subsidy_draft.prefecture
end
json.city do
  json.partial! 'cities/city', city: subsidy_draft.city
end
