class UserFavoriteSubsidiesController < ApplicationController
  def create
    @user_favorite_subsidy = UserFavoriteSubsidy.find_or_initialize_by(
      subsidy_id: params[:subsidy_id],
      user: current_user
    )
    if @user_favorite_subsidy.save
      render json: { success: true }, status: 200
    else
      render json: { message: '更新に失敗しました' }, status: 400
    end
  end
end
