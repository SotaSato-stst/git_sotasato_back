module Admin
  class SubsidyDraftsAssigneesController < ApplicationController
    def index
      @subsidy_draft_total = SubsidyDraft.not_archived.count
      @no_assign_total = SubsidyDraft.not_archived.not_assigned.count
      assign_count = SubsidyDraft.assigned.group(:assignee_id).count
      completed_count = SubsidyDraft.assigned.archived.group(:assignee_id).count
      @assignees = User.operators.map do |user|
        {
          user_id: user.id,
          user_name: user.display_name,
          assign_count: assign_count[user.id].to_i,
          completed_count: completed_count[user.id].to_i
        }
      end
      @assignees = @assignees.sort_by do |hash|
        -hash[:assign_count]
      end
    end

    def update
      assignee = User.operators.find(params[:assignee_id])
      scope = SubsidyDraft.not_archived.not_assigned.limit(params[:assign_count].to_i)
      assign_count = scope.update_all(assignee_id: assignee.id)
      render json: { message: '担当数を増やしました', assign_count: assign_count }, status: 200
    rescue StandardError => e
      render json: { message: '入力内容を確認してください', errors: [e.message] }, status: 400
    end

    def destroy
      assignee = User.operators.find(params[:assignee_id])
      scope = assignee.subsidy_draft_assngins.limit(params[:assign_count].to_i)
      assign_count = scope.update_all(assignee_id: nil)
      render json: { message: '担当数を減らしました', assign_count: assign_count }, status: 200
    rescue StandardError => e
      render json: { message: '入力内容を確認してください', errors: [e.message] }, status: 400
    end

    private

    def controller_action_authrized?
      current_user.admin?
    end
  end
end
