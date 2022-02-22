json.subsidies @subsidies, partial: 'admin/subsidies/subsidy', as: :subsidy
json.partial! '/pagination', paginated_records: @subsidies, items_total: @items_total
