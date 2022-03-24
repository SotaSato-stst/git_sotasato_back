module Business
  class BaseController < ApplicationController
    before_action :verify_token

    def verify_token
      authenticate_or_request_with_http_token do |token, _|
        uid = TokenVerifier.new(token).execute
        @current_user = User.activated.find_by!(firebase_uid: uid)
        @token = token
      end
    rescue TokenVerifier::InvalidTokenError
      render json: { message: 'ログインが必要です' }, status: 401
    rescue ActiveRecord::RecordNotFound
      render json: { message: '不正なユーザーです' }, status: 401
    end
  end
end
