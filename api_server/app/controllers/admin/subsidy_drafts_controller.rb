module Admin
  class SubsidyDraftsController < ApplicationController
    def index
      scope = SubsidyDraft.all.includes(:ministry, :prefecture, :city)
      @items_total = scope.count
      @subsidy_drafts = scope.page(params[:page]).per(100)
    end

    def show
      @subsidy_draft = SubsidyDraft.find(params[:id])
    end
  end
end
