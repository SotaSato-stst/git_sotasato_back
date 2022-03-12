# == Schema Information
#
# Table name: user_email_unsubscribes
#
#  id             :bigint           not null, primary key
#  email_category :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_user_email_unsubscribes_on_user_id  (user_id)
#
class UserEmailUnsubscribe < ApplicationRecord
  belongs_to :user
end
