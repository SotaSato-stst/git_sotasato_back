json.companies @companies, partial: 'admin/companies/company', as: :company
json.partial! '/pagination', paginated_records: @companies, items_total: @items_total
