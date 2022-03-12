# == Schema Information
#
# Table name: user_email_logs
#
#  id             :bigint           not null, primary key
#  email_category :string(255)      not null
#  sent_date      :date             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_user_email_logs_on_sent_date  (sent_date)
#  index_user_email_logs_on_user_id    (user_id)
#
FactoryBot.define do
  factory :user_email_log do
    association(:user)
    sent_date { Date.yesterday }
    email_category { 'new_subsidies' }
  end
end
