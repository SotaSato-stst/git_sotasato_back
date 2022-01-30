class ApplicationController < ActionController::API
  before_action :verify_token

  def verify_token
    uid = TokenVerifier.new(params['token']).execute
    @current_user = User.find_by(firebase_uid: uid)
  rescue TokenVerifier::InvalidTokenError
    render json: { message: 'ログインが必要です' }, status: 401
  end

  def current_user # rubocop:disable Style/TrivialAccessors
    @current_user
  end
end
