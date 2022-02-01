json.companies @companies, partial: 'admin/companies/company', as: :company
json.items_total @items_total
json.items_per_page @companies.count
json.current_page @companies.current_page
json.total_pages @companies.total_pages
