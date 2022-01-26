class BusinessCategoriesController < ApplicationController
  def index
    render json: { business_categories: BusinessCategory.to_options }
  end
end
