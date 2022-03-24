module Tasks
  class ReportSubsidyStatsController < BaseController
    def show
      slack = SlackService.new
      slack.post_subsidy_stats
      render json: { success: true }, status: 200
    end
  end
end
