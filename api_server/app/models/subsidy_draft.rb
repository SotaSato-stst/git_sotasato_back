# == Schema Information
#
# Table name: subsidy_drafts
#
#  id                :bigint           not null, primary key
#  archived          :boolean          default(FALSE), not null
#  source_url_domain :string(255)      not null
#  supplier_type     :string(255)
#  title             :string(255)      not null
#  url               :text(65535)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  assignee_id       :bigint
#  city_id           :bigint
#  ministry_id       :bigint
#  prefecture_id     :bigint
#
# Indexes
#
#  index_subsidy_drafts_on_assignee_id    (assignee_id)
#  index_subsidy_drafts_on_city_id        (city_id)
#  index_subsidy_drafts_on_ministry_id    (ministry_id)
#  index_subsidy_drafts_on_prefecture_id  (prefecture_id)
#
# Foreign Keys
#
#  fk_rails_...  (assignee_id => users.id)
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (ministry_id => ministries.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#
class SubsidyDraft < ApplicationRecord
  belongs_to :ministry, optional: true
  belongs_to :prefecture, optional: true
  belongs_to :city, optional: true
  belongs_to :assignee, class_name: 'User', optional: true
  has_one :subsidy, foreign_key: :url, primary_key: :url

  enum supplier_type: { ministry: 'ministry', city: 'city', prefecture: 'prefecture' }

  scope :archived, -> { where(archived: true) }
  scope :not_archived, -> { where(archived: false) }
  scope :assigned, -> { where.not(assignee_id: nil) }
  scope :assigned_to, ->(user) { where(assignee_id: user.id) }
  scope :not_assigned, -> { where(assignee_id: nil) }
  scope :assign_filter, ->(assign_category, user) {
    case assign_category
    when 'assignedMe'
      assigned_to(user)
    when 'noAssign'
      not_assigned
    end
  }
  scope :complete_filter, ->(complete_category) {
    case complete_category
    when 'completed'
      archived
    when 'notCompleted'
      not_archived
    end
  }
end
