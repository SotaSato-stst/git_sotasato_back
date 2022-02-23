json.subsidy_draft_total @subsidy_draft_total
json.no_assign_total @no_assign_total
json.assignees @assignees.map do |assignee|
  json.merge! assignee
end
