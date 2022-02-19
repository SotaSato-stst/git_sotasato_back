class HealthCheckController < ApplicationController
  skip_before_action :verify_token, :check_permission

  def index
    render json: {}, status: :ok
  end
end
