json.assign_stat do
  json.subsidy_draft_total @subsidy_draft_total
  json.assigned_total @assigned_total
  json.no_assign_total @no_assign_total
  json.assigned_completed_total @assigned_completed_total
  json.no_assign_completed_total @no_assign_completed_total
end
json.assignees @assignees.map do |assignee|
  json.merge! assignee
end
