module Admin
  class UsersController < ApplicationController
    def index
      scope = User.all.includes(:company)
      @items_total = scope.count
      @users = scope.page(params[:page]).per(50)
    end

    def show
      @user = User.find(params[:id])
    end

    def create
      firebase_uid = CreateAccountService.new(user_params[:email]).execute!
      @user = User.new(user_params.merge(firebase_uid: firebase_uid))
      set_association

      if @user.save
        render :show, status: 201
      else
        DeleteAccountService.new(firebase_uid).execute! if firebase_uid.present?
        render json: { message: @user.errors.message }, status: 400
      end
    rescue CreateAccountService::SignUpError => e
      render json: { message: e.message }, status: 400
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
      params.permit(:display_name, :email, :account_role)
    end

    def set_association
      @user.company = Company.where(params[:company_id]).first
    end
  end
end
