module Admin
  class SubsidyDraftsController < ApplicationController
    def index
      scope = SubsidyDraft.not_archived.includes(:ministry, :prefecture, :city)
      @items_total = scope.count
      @subsidy_drafts = scope.page(params[:page]).per(50)
    end

    def show
      @subsidy_draft = SubsidyDraft.find(params[:id])
    end

    def destroy
      @subsidy_draft = SubsidyDraft.find(params[:id])
      @subsidy_draft.update!(archived: true)
      render json: { success: true }, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 400
    end
  end
end
