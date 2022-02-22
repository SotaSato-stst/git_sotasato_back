class SubsidiesController < ApplicationController
  after_action :save_search_keyword, only: :index

  def index
    scope = Subsidy.search_by_user(search_params).includes(:ministry, :prefecture, :city, :subsidy_business_categories)
    @items_total = scope.count
    @subsidies = scope.page(params[:page]).per(20)
    @current_user_favorite_ids = current_user.user_favorite_subsidies.pluck(:subsidy_id) & @subsidies.map(&:id)
  end

  def show
    @subsidy = Subsidy.published.find(params[:id])
    @current_user_favorite_ids = current_user.user_favorite_subsidies.pluck(:subsidy_id)
  end

  def preview
    @subsidy = Subsidy.find(params[:id])
    render :show
  end

  private

  def search_params
    params.slice(:keyword, :prefecture_id, :city_ids, :in_application_period, :business_category_keys, :total_employee, :capital)
  end

  def controller_action_authrized?
    return false if params[:action] == 'preview' && current_user.user?

    current_user.present?
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
