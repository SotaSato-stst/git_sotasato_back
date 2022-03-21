class ApplicationMailer < ActionMailer::Base
  before_action :set_url
  default from: '補助金ドック <no-reply@hojokin-dock.com>', reply_to: 'info@hojokin-dock.com'
  layout 'mailer'

  def set_url
    @unsubscribe_url = "#{Settings.front_base_url}/email-setting"
    @top_url = Settings.front_base_url
  end
end
