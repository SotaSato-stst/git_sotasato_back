class PrefecturesController < ApplicationController
  def index
    @prefectures = Prefecture.all
  end

  private

  def controller_action_authrized?
    current_user.present?
  end
end
