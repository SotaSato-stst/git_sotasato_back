class UserFavoriteSubsidiesController < ApplicationController
  def create
    @user_favorite_subsidy = UserFavoriteSubsidy.new(subsidy_id: params[:subsidy_id], user_id: current_user.id)
    if @user_favorite_subsidy.save
      render :show, status: 201
    else
      render json: { message: '更新に失敗しました' }, status: 400
    end
  end
end
