# == Schema Information
#
# Table name: app_users
#
#  id           :bigint           not null, primary key
#  birthday     :date             not null
#  email        :string(255)      not null
#  firebase_uid :string(255)      not null
#  first_name   :string(255)      not null
#  gender       :string(255)      not null
#  last_name    :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_app_users_on_email         (email) UNIQUE
#  index_app_users_on_firebase_uid  (firebase_uid) UNIQUE
#
class AppUser < ApplicationRecord
  has_one :family

  enum gender: { male: 'male', female: 'female' }
end
