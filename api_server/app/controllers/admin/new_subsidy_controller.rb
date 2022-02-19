module Admin
  class NewSubsidyController < ApplicationController
    def show
      NewSubsidyService.new(params[:date].to_date).execute!
      render json: { success: true }, status: 200
    end

    private

    def controller_action_authrized?
      current_user.admin?
    end
  end
end
