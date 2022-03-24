module Business
  class CurrentUsersController < ApplicationController
    def show
      @company = current_user.company
    end

    def update
      if @current_user.update(update_params)
        @company = current_user.company
        render :show
      else
        render json: { message: '更新に失敗しました', errors: @current_user.errors.full_messages }, status: 400
      end
    end

    private

    def update_params
      params.permit(:last_name, :first_name, :email)
    end

    def controller_action_authrized?
      current_user.present?
    end
  end
end
