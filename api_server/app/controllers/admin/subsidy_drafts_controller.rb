module Admin
  class SubsidyDraftsController < BaseController
    def index
      scope = SubsidyDraft.index_loading.order(updated_at: :desc)
      scope =
        scope
        .assign_filter(params[:assign_filter], current_user)
        .complete_filter(params[:complete_filter])
        .benefit_filter(params[:benefit_filter])
        .search_title(params[:keyword])
      @items_total = scope.count
      @subsidy_drafts = scope.page(params[:page]).per(50)
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

    def bulk_archive
      SubsidyDraft.where(id: params[:ids]).update_all(archived: true, assignee_id: current_user.id)
      render json: { success: true }, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 400
    end

    def bulk_update_for_benefit
      SubsidyDraft.where(id: params[:ids]).update_all(for_benefit: params[:for_benefit], assignee_id: current_user.id)
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
