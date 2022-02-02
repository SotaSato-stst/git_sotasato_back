class SubsidiesController < ApplicationController
  def index
    scope = Subsidy.search_by_user(search_params).includes(:ministry, :prefecture, :city)
    @items_total = scope.count
    @subsidies = scope.page(params[:page]).per(20)
  end

  def show
    @subsidy = Subsidy.find(params[:id])
  end

  private

  def search_params
    params.slice(:prefecture_ids, :city_ids)
  end
end
