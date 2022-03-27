module Admin
  class BenefitsController < BaseController
    def index
      scope = Benefit.all.index_loading
      filter_params = params.slice(:publishing_code, :end_after, :keyword)
      scope = scope.admin_filter(filter_params).admin_sort(params[:sorting_code]).order(updated_at: :desc)
      @items_total = scope.count
      @benefits = scope.page(params[:page]).per(20)
    end

    def show
      @benefit = Benefit.find(params[:id])
    end

    def create
      @benefit = Benefit.new(benefit_params)
      set_association

      if @benefit.save
        SubsidyDraft.find_by(url: params[:url])&.update(archived: true, assignee: current_user)
        render :show, status: 201
      else
        render json: { message: '入力内容を確認してください', errors: @benefit.errors.full_messages }, status: 400
      end
    end

    def update
      @benefit = Benefit.find(params[:id])
      @benefit.assign_attributes(benefit_params)
      set_association

      if @benefit.save
        render :show, status: 201
      else
        render json: { message: '入力内容を確認してください', errors: @benefit.errors.full_messages }, status: 400
      end
    end

    private

    def benefit_params
      params.permit(
        :title,
        :url,
        :prefecture_id,
        :city_id,
        :target_detail,
        :price_detail,
        :application_detail,
        :end_date,
        :for_welfare,
        :for_elderly_care,
        :for_widow,
        :for_disabled,
        :age_from,
        :age_to,
        :household_income_from,
        :household_income_to
      )
    end

    def controller_action_authrized?
      current_user.admin? || current_user.editor?
    end
  end
end
