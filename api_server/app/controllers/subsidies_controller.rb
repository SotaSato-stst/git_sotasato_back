class SubsidiesController < ApplicationController
  def index
    scope = Subsidy.published.includes(:ministry, :prefecture, :city)
    @items_total = scope.count
    @subsidies = scope.page(params[:page]).per(20)
    @current_user_favorite_ids = current_user.user_favorite_subsidies.pluck(:subsidy_id) & @subsidies.map(&:id)
  end

  def show
    @subsidy = Subsidy.find(params[:id])
  end
end
