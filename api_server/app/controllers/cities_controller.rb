class CitiesController < ApplicationController
  def index
    @cities = Prefecture.find(params[:prefecture_id]).cities
  end
end
