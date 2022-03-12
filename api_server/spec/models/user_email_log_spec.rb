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
require 'rails_helper'

RSpec.describe UserEmailLog, type: :model do
  describe '#create' do
    it do
      expect(create(:user_email_log)).to be_present
    end
  end
end
