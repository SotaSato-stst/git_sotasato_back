module Admin
  class NewSubsidyController < ApplicationController
    def show
      next_id = SubsidyDraft.last&.id.to_i + 1
      NewSubsidyService.new(params[:date].to_date).execute!
      slack = SlackService.new
      SubsidyDraft.where(id: next_id..).limit(20).each do |subsidy_draft|
        slack.post_new_subsidy_draft(subsidy_draft)
      end
      slack.post_new_subsidies_count unless SubsidyDraft.not_archived.count.zero?
      render json: { success: true }, status: 200
    end

    private

    def controller_action_authrized?
      current_user.admin?
    end
  end
end
