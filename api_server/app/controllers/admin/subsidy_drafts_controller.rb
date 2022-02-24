module Admin
  class SubsidyDraftsController < ApplicationController
    def index
      scope = SubsidyDraft.includes(:ministry, :prefecture, :city, :assignee, :subsidy).order(updated_at: :desc)
      scope = scope.assign_filter(params[:assign_filter], current_user).complete_filter(params[:complete_filter])
      @items_total = scope.count
      @subsidy_drafts = scope.page(params[:page]).per(30)
    end

    def show
      @subsidy_draft = SubsidyDraft.find(params[:id])
    end

    def update
      @subsidy_draft = SubsidyDraft.find(params[:id])
      archived = ActiveModel::Type::Boolean.new.cast(params[:archived])
      @subsidy_draft.update!(archived: archived, assignee: current_user)
      render json: { success: true }, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 400
    end

    private

    def controller_action_authrized?
      current_user.admin? || current_user.editor?
    end
  end
end
