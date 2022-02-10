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
      service = FirebaseAccountService.new
      firebase_uid = service.sign_up!(signup_user_params[:email])
      @user = User.new(signup_user_params.merge(firebase_uid: firebase_uid))
      set_association

      @user.save!
      render :show, status: 201
    rescue StandardError => e
      service.delete!(firebase_uid) if firebase_uid.present? # rollback
      errors = []
      case e.message
      when 'EMAIL_EXISTS'
        errors << 'メールアドレスはすでに登録されています'
      end
      render json: { message: 'ユーザーの作成に失敗しました', errors: errors }, status: 400
    end

    def update
      @user = User.find(params[:id])
      @user.assign_attributes(update_user_params)
      set_association

      if @user.save
        render :show, status: 200
      else
        render json: { message: '更新に失敗しました' }, status: 400
      end
    end

    private

    def signup_user_params
      params.permit(:display_name, :email, :account_role)
    end

    def update_user_params
      params.permit(:display_name, :account_role) # emailはユーザー自身で更新可能
    end

    def set_association
      @user.company ||= Company.where(id: params[:company_id]).first
    end
  end
end
