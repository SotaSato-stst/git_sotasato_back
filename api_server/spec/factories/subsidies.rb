# == Schema Information
#
# Table name: subsidies
#
#  id                :bigint           not null, primary key
#  detail            :text(65535)      not null
#  end_to            :date
#  level             :integer
#  price_max         :integer
#  publishing_code   :string(255)      not null
#  start_from        :date             not null
#  subsidy_category  :string(255)
#  supplier_type     :string(255)
#  support_ratio_max :string(255)
#  support_ratio_min :string(255)
#  target_detail     :text(65535)      not null
#  title             :string(255)      not null
#  url               :text(65535)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_subsidies_on_url  (url) UNIQUE
#
FactoryBot.define do
  factory :subsidy do
    title { 'title' }
    url { 'https://example.com/page1' }
    start_from { '2021-4-24' }
    end_to { '2021-4-29' }
    publishing_code { 'published' }
    level { '4' }
    detail { 'アイウエオ' }
    target_detail { '対象の説明文' }
    subsidy_category { 'hojo' }
    supplier_type { nil }
  end
end
