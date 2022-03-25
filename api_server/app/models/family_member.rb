# == Schema Information
#
# Table name: family_members
#
#  id           :bigint           not null, primary key
#  birthday     :date             not null
#  relationship :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  family_id    :bigint           not null
#
# Indexes
#
#  index_family_members_on_family_id  (family_id)
#
# Foreign Keys
#
#  fk_rails_...  (family_id => families.id)
#
class FamilyMember < ApplicationRecord
  belongs_to :family

  enum relationship: {
    child: 'child',
    spouse: 'spouse',
    relationship_parent: 'relationship_parent', # 予約語回避
    grand_parent: 'grand_parent',
    grand_child: 'grand_child',
    other: 'other'
  }
end
