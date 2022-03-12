# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  account_role :string(255)      default("user"), not null
#  disabled     :boolean          default(FALSE)
#  display_name :string(255)      default(""), not null
#  email        :string(255)      default(""), not null
#  firebase_uid :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :bigint           not null
#
# Indexes
#
#  index_users_on_company_id    (company_id)
#  index_users_on_firebase_uid  (firebase_uid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class User < ApplicationRecord
  belongs_to :company
  has_many :user_favorite_subsidies, dependent: :destroy
  has_many :subsidies, through: :user_favorite_subsidies
  has_many :subsidy_draft_assngins, foreign_key: :assignee_id, class_name: 'SubsidyDraft'
  has_many :user_email_logs, dependent: :destroy
  has_many :user_email_unsubscribes, dependent: :destroy

  enum account_role: { user: 'user', editor: 'editor', admin: 'admin' } # editor: 補助金情報の入力者, admin: 社内の管理者

  scope :activated, -> { where(disabled: false) }
  scope :operators, -> { where(account_role: %w[editor admin]) }
  scope :email_subscribers, ->(email_category) do
    unsubscribers = UserEmailUnsubscribe.where(email_category: email_category).pluck(:user_id)
    activated.where(account_role: %w[user admin]).where.not(id: unsubscribers)
  end
end
