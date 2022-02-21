module Admin
  class NewSubsidyController < ApplicationController
    def show
      NewSubsidyService.new(params[:date].to_date).execute!
      slack = SlackService.new
      SubsidyDraft.where(created_at: 10.minutes.ago..).each do |subsidy_draft|
        slack.post_new_subsidy_draft(subsidy_draft)
      end
      slack.post_new_subsidies_count
      render json: { success: true }, status: 200
    end

    private

    def controller_action_authrized?
      current_user.admin?
    end
  end
end
