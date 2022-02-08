class UserFavoriteSubsidiesController < ApplicationController
  def create
    user_favorite_subsidy = UserFavoriteSubsidy.find_or_initialize_by(
      subsidy_id: params[:subsidy_id],
      user: current_user
    )
    if user_favorite_subsidy.save
      render json: { success: true }, status: 200
    else
      render json: { message: '更新に失敗しました' }, status: 400
    end
  end

  def destroy
    user_favorite_subsidy = UserFavoriteSubsidy.find_by(
      subsidy_id: params[:id],
      user: current_user
    )
    if user_favorite_subsidy.present? && user_favorite_subsidy.destroy
      render json: { success: true }, status: 200
    else
      render json: { message: '更新に失敗しました' }, status: 400
    end
  end
end
