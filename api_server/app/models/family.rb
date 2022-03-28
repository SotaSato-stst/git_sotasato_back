# == Schema Information
#
# Table name: families
#
#  id               :bigint           not null, primary key
#  has_disabled     :boolean
#  has_widow        :boolean
#  household_income :integer
#  on_elderly_care  :boolean
#  on_welfare       :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  city_id          :bigint           not null
#  prefecture_id    :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_families_on_city_id        (city_id)
#  index_families_on_prefecture_id  (prefecture_id)
#  index_families_on_user_id        (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#  fk_rails_...  (user_id => users.id)
#
class Family < ApplicationRecord
  belongs_to :prefecture
  belongs_to :city
  belongs_to :user # 世帯主
  has_many :family_members # 世帯員
end
