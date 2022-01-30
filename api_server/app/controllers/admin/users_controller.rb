module Admin
  class UsersController < ApplicationController
    def index
      @users = User.all.includes(:company)
    end

    def show
      @user = User.find(params[:id])
    end

    def create
      @user = User.new(user_params)
      set_association

      if @user.save
        render :show, status: 201
      else
        render json: { message: '更新に失敗しました' }, status: 400
      end
    end

    def update
      @user = User.find(params[:id])
      @user.assign_attributes(user_params)
      set_association

      if @user.save
        render :show, status: 200
      else
        render json: { message: '更新に失敗しました' }, status: 400
      end
    end

    private

    def user_params
      params.permit(:display_name, :email, :firebase_uid, :account_role)
    end

    def set_association
      @user.company = Company.where(params[:company_id]).first
    end
  end
end
