module Admin
  class SubsidyDraftsController < ApplicationController
    def index
      scope = SubsidyDraft.includes(:ministry, :prefecture, :city, :assignee).order(updated_at: :desc)
      case params[:assign_filter]
      when 'assignedMe'
        scope = scope.assigned_to(current_user)
      when 'noAssign'
        scope = scope.not_assigned
      end
      case params[:complete_filter]
      when 'completed'
        scope = scope.archived
      when 'notCompleted'
        scope = scope.not_archived
      end
      @items_total = scope.count
      @subsidy_drafts = scope.page(params[:page]).per(30)
    end

    def show
      @subsidy_draft = SubsidyDraft.find(params[:id])
    end

    def destroy
      @subsidy_draft = SubsidyDraft.find(params[:id])
      @subsidy_draft.update!(archived: true, assignee: current_user)
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
