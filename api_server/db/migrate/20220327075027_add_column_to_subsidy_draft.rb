class AddColumnToSubsidyDraft < ActiveRecord::Migration[6.1]
  def change
    add_column :subsidy_drafts, :for_benefit, :boolean, default: false
  end
end
