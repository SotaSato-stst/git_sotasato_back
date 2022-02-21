module Admin
  class TopKeywordsController < ApplicationController
    def index
      top_keywords = SearchedKeyword.group(:content).count.sort_by { |_, v| -v }.first(50).map(&:first)
      render json: { keywords: top_keywords }, status: 200
    end

    private

    def controller_action_authrized?
      current_user.admin?
    end
  end
end
