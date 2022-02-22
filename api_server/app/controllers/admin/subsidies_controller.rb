module Admin
  class SubsidiesController < ApplicationController
    def index
      scope = Subsidy.all.includes(
        :ministry,
        :prefecture,
        :city,
        :subsidy_business_categories,
        { subsidy_keywords: :keyword }
      )
      @items_total = scope.count
      @subsidies = scope.page(params[:page]).per(20)
    end

    def show
      @subsidy = Subsidy.find(params[:id])
    end

    def create
      @subsidy = Subsidy.new(subsidy_params)
      set_association

      if @subsidy.save
        SubsidyDraft.find_by(url: params[:url])&.destroy
        render :show, status: 201
      else
        render json: { message: '入力内容を確認してください', errors: @subsidy.errors.full_messages }, status: 400
      end
    end

    def update
      @subsidy = Subsidy.find(params[:id])
      @subsidy.assign_attributes(subsidy_params)
      set_association

      if @subsidy.save
        render :show, status: 201
      else
        render json: { message: '入力内容を確認してください', errors: @subsidy.errors.full_messages }, status: 400
      end
    end

    private

    def subsidy_params
      params.permit(
        :title,
        :publishing_code,
        :url,
        :subsidy_category,
        :supplier_type,
        :start_from,
        :end_to,
        :price_max,
        :support_ratio_min,
        :support_ratio_max,
        :level,
        :detail,
        :target_detail,
        :ranking_score,
        :total_employee_max,
        :total_employee_min,
        :capital_max,
        :capital_min,
        :founding_date_max,
        :founding_date_min,
        :annual_sales_max,
        :annual_sales_min,
      )
    end

    def set_association
      @subsidy.ministry = Ministry.where(id: params[:ministry_id]).first
      @subsidy.prefecture = Prefecture.where(id: params[:prefecture_id]).first
      @subsidy.city = City.where(id: params[:city_id]).first
      business_category_keys = params.permit(:business_categories)[:business_categories]
      @subsidy.subsidy_business_categories = business_category_keys.to_a.map do |category|
        @subsidy.subsidy_business_categories.build(business_category: category)
      end
      keywords = params.permit(:keywords)[:keywords].split(/[[:space:]]/)
      @subsidy.subsidy_keywords = keywords.to_a.map do |content|
        keyword = Keyword.create_or_find_by(content: content)
        @subsidy.subsidy_keywords.build(keyword: keyword)
      end
    end

    def controller_action_authrized?
      current_user.admin? || current_user.editor?
    end
  end
end
