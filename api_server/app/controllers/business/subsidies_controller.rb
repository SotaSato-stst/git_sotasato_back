module Business
  class SubsidiesController < BaseController
    after_action :save_search_keyword, only: :index

    def index
      scope = Subsidy.index_loading.search_by_user(search_params)
      @items_total = scope.count
      @subsidies = scope.page(params[:page]).per(20)
      @current_user_favorite_ids = current_user.user_favorite_subsidies.pluck(:subsidy_id) & @subsidies.map(&:id)
    end

    def show
      @subsidy = Subsidy.published.find(params[:id])
      @current_user_favorite_ids = current_user.user_favorite_subsidies.pluck(:subsidy_id)
    rescue ActiveRecord::RecordNotFound
      render json: { message: 'ページが見つかりません' }, status: 404
    end

    def preview
      if current_user.user? # 管理者、データ編集者用
        render json: { message: '権限がありません' }, status: 403
      else
        @subsidy = Subsidy.find(params[:id])
        render :show
      end
    end

    private

    def search_params
      params.slice(
        :keyword,
        :organization_type,
        :prefecture_id,
        :city_id,
        :in_application_period,
        :business_categories,
        :total_employee,
        :capital,
        :founding_date,
        :annual_sales
      )
    end

    def save_search_keyword
      return if params[:keyword].blank?

      keyword_contents = params[:keyword].split(/[[:space:]]/)
      keyword_contents.each do |content|
        keyword = Keyword.find_by(content: content)
        SearchedKeyword.create(user: current_user, content: content, keyword: keyword, hit_count: @items_total)
      end
    end
  end
end