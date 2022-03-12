# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def daily_new_subsidies
    UserMailer.daily_new_subsidies(User.first, Subsidy.limit(20))
  end
end
