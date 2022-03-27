json.call(subsidy_draft, :id, :title, :url, :supplier_type, :for_benefit, :archived, :created_at)
json.subsidy_id subsidy_draft.subsidy&.id

json.assignee do
  if subsidy_draft.assignee.present?
    json.call(
      subsidy_draft.assignee,
      :id,
      :display_name,
      :last_name,
      :first_name,
      :email,
      :firebase_uid,
      :account_role,
      :disabled
    )
  else
    json.null!
  end
end
json.ministry do
  json.partial! 'ministries/ministry', ministry: subsidy_draft.ministry
end
json.prefecture do
  json.partial! 'prefectures/prefecture', prefecture: subsidy_draft.prefecture
end
json.city do
  json.partial! 'cities/city', city: subsidy_draft.city
end
