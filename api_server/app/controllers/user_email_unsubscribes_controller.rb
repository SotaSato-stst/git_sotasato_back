class UserEmailUnsubscribesController < ApplicationController
  def index
    @user_email_unsubscribes = user.user_email_unsubscribes
  end

  def create
    user_email_unsubscribe = UserEmailUnsubscribe.find_or_initialize_by(
      user: current_user,
      email_category: params[:email_category]
    )
    if user_email_unsubscribe.save
      render json: { message: '購読を停止しました' }, status: 201
    else
      render json: { message: '更新に失敗しました', errors: @current_user.errors.full_messages }, status: 400
    end
  end

  def destroy
    user_email_unsubscribe = UserEmailUnsubscribe.find_or_initialize_by(
      user: current_user,
      email_category: params[:email_category]
    )
    if user_email_unsubscribe.new_record? || user_email_unsubscribe.destroy
      render json: { message: '購読を開始しました' }, status: 201
    else
      render json: { message: '更新に失敗しました', errors: @current_user.errors.full_messages }, status: 400
    end
  end

  private

  def controller_action_authrized?
    current_user.present?
  end
end
