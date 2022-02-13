class CitiesController < ApplicationController
  def index
    @cities = Prefecture.find(params[:prefecture_id]).cities
  end

  private

  def controller_action_authrized?
    current_user.present?
  end
end
