module Admin
  class SearchedKeywordsController < BaseController
    def index
      keywords = SearchedKeyword.keyword_stats
      render json: { keywords: keywords }, status: 200
    end

    private

    def controller_action_authrized?
      current_user.admin?
    end
  end
end
