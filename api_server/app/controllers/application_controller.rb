class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :verify_token, :check_permission

  def verify_token
    authenticate_or_request_with_http_token do |token, _|
      uid = TokenVerifier.new(token).execute
      @current_user = User.find_by!(firebase_uid: uid)
      @token = token
    end
  rescue TokenVerifier::InvalidTokenError
    render json: { message: 'ログインが必要です' }, status: 401
  end

  def current_user # rubocop:disable Style/TrivialAccessors
    @current_user
  end

  def check_permission
    permission =
      if params[:controller].start_with?('admin')
        current_user.admin?
      else
        true
      end

    render json: { message: '権限がありません' }, status: 403 unless permission
  end
end
