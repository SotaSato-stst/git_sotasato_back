module Tasks
  class NewSubsidyController < ApplicationController
    def show
      next_id = SubsidyDraft.last.id + 1
      NewSubsidyService.new(Date.today).execute!
      slack = SlackService.new
      SubsidyDraft.where(id: next_id..).each do |subsidy_draft|
        slack.post_new_subsidy_draft(subsidy_draft)
      end
      slack.post_new_subsidies_count
      render json: { success: true }, status: 200
    end
  end
end
