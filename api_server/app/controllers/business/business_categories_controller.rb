module Business
  class BusinessCategoriesController < ApplicationController
    def index
      render json: { business_categories: BusinessCategory.to_options }
    end

    private

    def controller_action_authrized?
      current_user.present?
    end
  end
end
