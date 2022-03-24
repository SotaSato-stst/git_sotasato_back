class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  def current_user # rubocop:disable Style/TrivialAccessors
    @current_user
  end
end
