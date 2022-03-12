class ApplicationMailer < ActionMailer::Base
  before_action :set_url
  default from: 'yoshimi.kondo@k-to.llc', reply_to: 'yoshimi.kondo@k-to.llc'
  layout 'mailer'

  def set_url
    @unsubscribe_url = "#{Settings.front_base_url}/email-setting"
    @top_url = Settings.front_base_url
  end
end
