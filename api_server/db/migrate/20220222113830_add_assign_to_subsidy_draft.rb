class AddAssignToSubsidyDraft < ActiveRecord::Migration[6.1]
  def change
    add_reference :subsidy_drafts, :assignee, index: true, foreign_key: { to_table: :users }
  end
end
