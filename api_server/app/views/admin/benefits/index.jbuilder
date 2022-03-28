json.benefits @benefits, partial: 'admin/benefits/benefit', as: :benefit
json.partial! '/pagination', paginated_records: @benefits, items_total: @items_total
