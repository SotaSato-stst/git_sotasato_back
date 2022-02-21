json.call(user, :id, :display_name, :email, :firebase_uid, :account_role, :disabled)

json.company do
  json.id user.company.id
  json.name user.company.name
end
