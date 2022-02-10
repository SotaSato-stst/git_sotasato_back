json.pagination do
  json.items_total items_total
  json.items_per_page paginated_records.limit_value
  json.current_page paginated_records.current_page
  json.total_pages paginated_records.total_pages
end
