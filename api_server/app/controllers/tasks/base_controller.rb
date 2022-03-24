module Tasks
  class BaseController < ApplicationController
    before_action :check_cron

    def check_cron
      cron = request.headers['X-Appengine-Cron']
      unless ActiveModel::Type::Boolean.new.cast(cron)
        raise "#{params[:action]}への不正なアクセス"
      end
    end
  end
end
