class RankingSubsidiesController < ApplicationController
  def index
    @ranking_subsidies = Subsidy.published.order(ranking_score: :desc).includes(
      :ministry, :prefecture, :city
    ).limit(10)
    @current_user_favorite_ids = current_user.user_favorite_subsidies.pluck(:subsidy_id) & @ranking_subsidies.map(&:id)
  end

  private

  def controller_action_authrized?
    current_user.present?
  end
end
