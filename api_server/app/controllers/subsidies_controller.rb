class SubsidiesController < ApplicationController
  def index
    @subsidies = Subsidy.all.includes(:ministry, :prefecture, :city)
  end

  def show
    @subsidy = Subsidy.find(params[:id])
  end
end
