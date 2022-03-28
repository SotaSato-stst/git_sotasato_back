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
class User < ApplicationRecord
  has_one :user_company
  has_one :company, through: :user_company
  has_one :family
  has_many :user_favorite_subsidies, dependent: :destroy
  has_many :subsidies, through: :user_favorite_subsidies
  has_many :subsidy_draft_assngins, foreign_key: :assignee_id, class_name: 'SubsidyDraft'
  has_many :user_email_logs, dependent: :destroy
  has_many :user_email_unsubscribes, dependent: :destroy

  enum account_role: {
    user: 'user', # 法人向けユーザー 通称: 補助金ドック(Web)
    family_user: 'family_user', # 家庭向けユーザー 通称: 未定(アプリ)
    editor: 'editor', # editor: 補助金情報の入力者
    admin: 'admin' # admin: 社内の管理者
  }

  scope :activated, -> { where(disabled: false) }
  scope :operators, -> { where(account_role: %w[editor admin]) }
  scope :email_subscribers, ->(email_category) do
    unsubscribers = UserEmailUnsubscribe.where(email_category: email_category).pluck(:user_id)
    activated.where(account_role: %w[user admin]).where.not(id: unsubscribers)
  end

  def display_name
    last_name + first_name
  end
end
