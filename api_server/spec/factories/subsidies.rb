# == Schema Information
#
# Table name: subsidies
#
#  id                     :bigint           not null, primary key
#  annual_sales_max       :bigint
#  annual_sales_min       :bigint
#  capital_max            :bigint
#  capital_min            :integer
#  detail                 :text(65535)      not null
#  end_to                 :date
#  level                  :integer
#  price_max              :bigint
#  publishing_code        :string(255)      not null
#  ranking_score          :integer
#  start_from             :date             not null
#  subsidy_category       :string(255)
#  supplier_type          :string(255)
#  support_ratio_max      :string(255)
#  support_ratio_min      :string(255)
#  target_detail          :text(65535)      not null
#  title                  :string(255)      not null
#  total_employee_max     :integer
#  total_employee_min     :integer
#  url                    :text(65535)      not null
#  years_of_establishment :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_subsidies_on_url  (url) UNIQUE
#
FactoryBot.define do
  factory :subsidy do
    title { 'title' }
    sequence(:url, 'https://example.com/page1')
    start_from { '2000-4-24' }
    end_to { '2021-4-29' }
    publishing_code { 'published' }
    level { '4' }
    detail { 'アイウエオ' }
    target_detail { '対象の説明文' }
    price_max { 10_000_000 }
    subsidy_category { 'hojo' }
    ranking_score { 30 }
    total_employee_max { 100 }
    total_employee_min { 30 }
    capital_max { 3000 }
    capital_min { 30 }

    transient do
      ministry { nil }
      prefecture { nil }
      city { nil }
      business_categories { nil }
    end

    subsidy_ministry do |this|
      association(:subsidy_ministry, subsidy: this.instance, ministry: ministry) if ministry
    end
    subsidy_prefecture do |this|
      association(:subsidy_prefecture, subsidy: this.instance, prefecture: prefecture) if prefecture
    end
    subsidy_city do |this|
      association(:subsidy_city, subsidy: this.instance, city: city) if city
    end
    subsidy_business_categories do |this|
      business_categories.to_a.map do |category|
        association(:subsidy_business_category, subsidy: this.instance, business_category: category)
      end
    end
  end
end
