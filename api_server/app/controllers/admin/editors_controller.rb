module Admin
  class EditorsController < ApplicationController
    def index
      scope = User.editor.includes(:company).order(updated_at: :desc)
      @items_total = scope.count
      @users = scope.page(params[:page]).per(50)
    end

    private

    def controller_action_authrized?
      current_user.admin?
    end
  end
end
