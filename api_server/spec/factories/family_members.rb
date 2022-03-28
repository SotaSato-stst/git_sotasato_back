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
FactoryBot.define do
  factory :family_member do
    family { create(:family) }
    birthday { 10.years.ago }
    relationship { 'child' }
  end
end
