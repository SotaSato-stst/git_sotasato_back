json.subsidy_drafts @subsidy_drafts, partial: 'admin/subsidy_drafts/subsidy_draft', as: :subsidy_draft
json.partial! '/pagination', paginated_records: @subsidy_drafts, items_total: @items_total
