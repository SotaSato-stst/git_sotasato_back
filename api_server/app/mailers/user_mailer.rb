class UserMailer < ApplicationMailer
  def daily_new_subsidies(user, subsidies)
    @user = user
    @subsidies = subsidies
    @subject = '新着情報のお知らせ | 補助金ドック'
    # https://developers.google.com/analytics/devguides/collection/protocol/v1/email
    tracking_params = {
      tid: Settings.analytics_id,
      t: 'event',
      ec: 'email',
      ea: 'open',
      dp: '/email/daily_new_subsidies',
      dt: @subject
    }.to_param
    @tracking_code = "https://www.google-analytics.com/collect?v=1&#{tracking_params}"
    mail(to: @user.email, subject: @subject)
  end
end
