class UserMailer < ApplicationMailer
  def daily_new_subsidies(user, subsidies)
    @user = user
    @subsidies = subsidies
    @subject = '新着の補助金情報をお届けします'
    mail(to: @user.email, subject: @subject)
  end
end
