json.subsidies @favorite_subsidies, partial: 'business/subsidies/subsidy', as: :subsidy
json.partial! '/pagination', paginated_records: @favorite_subsidies, items_total: @items_total
