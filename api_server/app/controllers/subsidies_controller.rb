class SubsidiesController < ApplicationController
  def index
    @subsidies = Subsidy.all.includes(:supplier)
  end

  def show
    @subsidy = Subsidy.find(params[:id])
  end
end
