class MinistriesController < ApplicationController
  def index
    @ministries = Ministry.all
  end

  private

  def controller_action_authrized?
    current_user.present?
  end
end
