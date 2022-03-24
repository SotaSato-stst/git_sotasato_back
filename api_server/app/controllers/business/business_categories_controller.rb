module Business
  class BusinessCategoriesController < BaseController
    def index
      render json: { business_categories: BusinessCategory.to_options }
    end
  end
end
