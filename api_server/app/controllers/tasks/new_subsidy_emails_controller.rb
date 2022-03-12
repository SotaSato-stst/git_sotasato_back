module Tasks
  class NewSubsidyController < ApplicationController
    def show
      NewSubsidyEmailsService.new.execute!
      render json: { success: true }, status: 200
    end
  end
end
