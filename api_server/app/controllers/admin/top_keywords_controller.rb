module Admin
  class TopKeywordsController < BaseController
    def index
      top_keywords = SearchedKeyword.top_keywords(50)
      render json: { keywords: top_keywords }, status: 200
    end

    private

    def controller_action_authrized?
      current_user.admin? || current_user.editor?
    end
  end
end
