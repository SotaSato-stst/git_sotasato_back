class CurrentUsersController < ApplicationController
  def show; end

  def update
    if @current_user.update(update_params)
      render :show
    else
      render json: { message: '更新に失敗しました', errors: @current_user.errors.full_messages }, status: 400
    end
  end

  private

  def update_params
    params.permit(:display_name, :email)
  end
end
