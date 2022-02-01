class SubsidiesController < ApplicationController
  def index
    scope = Subsidy.published.includes(:ministry, :prefecture, :city)
    @items_total = scope.count
    @subsidies = scope.page(params[:page]).per(20)
  end

  def show
    @subsidy = Subsidy.find(params[:id])
  end
end
