json.call(user, :id, :display_name, :last_name, :first_name, :email, :account_role, :disabled)

json.company do
  json.id user.company.id
  json.name user.company.name
end
