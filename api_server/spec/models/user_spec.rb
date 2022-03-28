# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  account_role :string(255)      default("user"), not null
#  disabled     :boolean          default(FALSE)
#  email        :string(255)      default(""), not null
#  firebase_uid :string(255)      not null
#  first_name   :string(255)      not null
#  last_name    :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_firebase_uid  (firebase_uid) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    it do
      expect(create(:user)).to be_present
    end
  end
end
