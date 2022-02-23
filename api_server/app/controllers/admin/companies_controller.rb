module Admin
  class CompaniesController < ApplicationController
    def index
      scope = Company.all.includes(:prefecture, :city, :company_business_categories).order(updated_at: :desc)
      @items_total = scope.count
      @companies = scope.page(params[:page]).per(20)
    end

    def show
      @company = Company.find(params[:id])
    end

    def create
      @company = Company.new(company_params)
      set_association

      if @company.save
        render :show, status: 201
      else
        render json: { message: '更新に失敗しました' }, status: 400
      end
    end

    def update
      @company = Company.find(params[:id])
      @company.assign_attributes(company_params)
      set_association
      if @company.save
        render :show, status: 200
      else
        render json: { message: '更新に失敗しました' }, status: 400
      end
    end

    private

    def company_params
      params.permit(:name, :organization_type, :adress, :total_employee, :capital, :founding_date, :annual_sales)
    end

    def set_association
      @company.prefecture = Prefecture.where(id: params[:prefecture_id]).first
      @company.city = City.where(id: params[:city_id]).first
      @company.company_business_categories = params[:business_categories].to_a.map do |business_category|
        @company.company_business_categories.build(business_category: business_category)
      end
    end

    def controller_action_authrized?
      current_user.admin?
    end
  end
end
