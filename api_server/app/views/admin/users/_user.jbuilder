json.call(user, :id, :display_name, :email, :firebase_uid)

json.company do
  json.partial! 'companies/company', company: user.company
end
