class RankingSubsidiesController < ApplicationController
  def index
    @ranking_subsidies = Subsidy.index_loading.scope_by_user(current_user).order(ranking_score: :desc).limit(10)
    @current_user_favorite_ids = current_user.user_favorite_subsidies.pluck(:subsidy_id) & @ranking_subsidies.map(&:id)
  end

  private

  def controller_action_authrized?
    current_user.present?
  end
end
