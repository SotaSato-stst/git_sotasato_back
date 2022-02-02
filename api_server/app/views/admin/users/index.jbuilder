json.users @users, partial: 'admin/users/user', as: :user
json.partial! '/pagination', paginated_records: @users, items_total: @items_total
