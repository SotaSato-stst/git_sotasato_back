class SubsidiesController < ApplicationController
  def index
    scope = Subsidy.search_by_user(search_params).includes(:ministry, :prefecture, :city, :subsidy_business_categories)
    @items_total = scope.count
    @subsidies = scope.page(params[:page]).per(20)
    @current_user_favorite_ids = current_user.user_favorite_subsidies.pluck(:subsidy_id) & @subsidies.map(&:id)
  end

  def show
    @subsidy = Subsidy.published.find(params[:id])
    @current_user_favorite_ids = current_user.user_favorite_subsidies.pluck(:subsidy_id)
  end

  private

  def search_params
    params.slice(:prefecture_id, :city_ids, :in_application_period, :business_category_keys, :total_employee, :capital)
  end

  def controller_action_authrized?
    current_user.present?
  end
end
