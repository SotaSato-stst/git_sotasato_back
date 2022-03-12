class UserMailer < ApplicationMailer
  def daily_new_subsidies(user, subsidies)
    @user = user
    @subsidies = subsidies
    @subject = '新着情報のお知らせ | 補助金ドック'
    mail(to: @user.email, subject: @subject)
  end
end
