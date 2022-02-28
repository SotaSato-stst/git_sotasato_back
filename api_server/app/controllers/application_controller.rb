class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :verify_token, :check_permission, unless: :request_from_cron?

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

  def current_user # rubocop:disable Style/TrivialAccessors
    @current_user
  end

  def check_permission
    render json: { message: '権限がありません' }, status: 403 unless controller_action_authrized?
  end

  def controller_action_authrized?
    raise '各controllerで定義すること'
  end

  def request_from_cron?
    return false unless params[:controller].start_with?('tasks/')

    cron = request.headers['X-Appengine-Cron']
    if ActiveModel::Type::Boolean.new.cast(cron)
      true
    else
      false
    end
  end
end
