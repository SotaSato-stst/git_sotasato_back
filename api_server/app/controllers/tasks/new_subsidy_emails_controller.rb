module Tasks
  class NewSubsidyEmailsController < BaseController
    def show
      NewSubsidyEmailsService.new.execute!
      render json: { success: true }, status: 200
    end
  end
end
