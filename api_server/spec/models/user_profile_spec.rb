# == Schema Information
#
# Table name: user_profiles
#
#  id         :bigint           not null, primary key
#  birthday   :date             not null
#  gender     :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_profiles_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe UserProfile, type: :model do
  describe '#create' do
    it do
      expect(create(:user_profile)).to be_present
    end
  end
end
