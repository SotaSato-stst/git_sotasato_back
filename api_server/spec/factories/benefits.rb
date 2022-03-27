# == Schema Information
#
# Table name: benefits
#
#  id                    :bigint           not null, primary key
#  age_from              :integer
#  age_to                :integer
#  application_detail    :text(65535)      not null
#  end_date              :date
#  for_disabled          :boolean          default(FALSE), not null
#  for_elderly_care      :boolean          default(FALSE), not null
#  for_welfare           :boolean          default(FALSE), not null
#  for_widow             :boolean          default(FALSE), not null
#  household_income_from :integer
#  household_income_to   :integer
#  price_detail          :text(65535)      not null
#  publishing_code       :string(255)      not null
#  target_detail         :text(65535)      not null
#  title                 :string(255)      not null
#  url                   :text(65535)      not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  city_id               :bigint
#  prefecture_id         :bigint
#
# Indexes
#
#  index_benefits_on_city_id          (city_id)
#  index_benefits_on_prefecture_id    (prefecture_id)
#  index_benefits_on_publishing_code  (publishing_code)
#  index_benefits_on_url              (url) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#
FactoryBot.define do
  factory :benefit do
    publishing_code { 'published' }
    title { 'タイトル' }
    sequence(:url, 'https://example.com/1')
    prefecture { create(:prefecture) }
    city_id { create(:city) }
    price_detail { '支給内容' }
    target_detail { '対象内容' }
    application_detail { '申し込み方法' }
    age_from { nil }
    age_to { nil }
    end_date { 1.month.from_now }
    for_disabled { false }
    for_elderly_care { false }
    for_welfare { false }
    for_widow { false }
    household_income_from { nil }
    household_income_to { nil }
  end
end
