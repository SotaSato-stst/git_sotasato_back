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
#  app_user_id      :bigint           not null
#  city_id          :bigint           not null
#  prefecture_id    :bigint           not null
#
# Indexes
#
#  index_families_on_app_user_id    (app_user_id) UNIQUE
#  index_families_on_city_id        (city_id)
#  index_families_on_prefecture_id  (prefecture_id)
#
# Foreign Keys
#
#  fk_rails_...  (app_user_id => app_users.id)
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#
FactoryBot.define do
  factory :family do
    app_user { create(:app_user) }
    prefecture { create(:prefecture) }
    city { create(:city) }
    household_income { 1_000_000 }
    on_welfare { false }
    on_elderly_care { false }
    has_widow { false }
    has_disabled { false }
  end
end
