module Tasks
  class NewSubsidyController < ApplicationController
    def show
      NewSubsidyService.new(Date.today).execute!
      render json: { success: true }, status: 200
    end
  end
end
