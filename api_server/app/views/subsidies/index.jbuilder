json.subsidies @subsidies, partial: 'subsidies/subsidy', as: :subsidy
json.items_total @items_total
json.items_per_page @subsidies.count
json.current_page @subsidies.current_page
json.total_pages @subsidies.total_pages
