json.call(user, :id, :display_name, :email, :firebase_uid, :account_role)

json.company do
  json.partial! 'admin/companies/company', company: user.company
end
