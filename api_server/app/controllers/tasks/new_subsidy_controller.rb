module Tasks
  class NewSubsidyController < BaseController
    def show
      next_id = SubsidyDraft.last&.id.to_i + 1
      NewSubsidyService.new(Date.today).execute!
      slack = SlackService.new
      SubsidyDraft.where(id: next_id..).limit(20).each do |subsidy_draft|
        slack.post_new_subsidy_draft(subsidy_draft)
      end
      render json: { success: true }, status: 200
    end
  end
end
