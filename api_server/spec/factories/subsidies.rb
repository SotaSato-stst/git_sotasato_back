# == Schema Information
#
# Table name: subsidies
#
#  id                     :bigint           not null, primary key
#  annual_sales_max       :bigint
#  annual_sales_min       :bigint
#  capital_max            :bigint
#  capital_min            :bigint
#  catch_copy             :string(255)
#  detail                 :text(65535)      not null
#  end_to                 :date
#  level                  :integer
#  price_max              :bigint
#  publishing_code        :string(255)      not null
#  ranking_score          :integer
#  start_from             :date
#  subsidy_category       :string(255)
#  supplier_type          :string(255)
#  support_ratio_max      :string(255)
#  support_ratio_min      :string(255)
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
#  index_subsidies_on_price_max        (price_max)
#  index_subsidies_on_publishing_code  (publishing_code)
#  index_subsidies_on_ranking_score    (ranking_score)
#  index_subsidies_on_url              (url) UNIQUE
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
    price_max { 10_000_000 }
    subsidy_category { 'hojo' }
    ranking_score { 30 }
    total_employee_max { nil }
    total_employee_min { nil }
    capital_max { nil }
    capital_min { nil }
    years_of_establishment { 10 }
    annual_sales_max { 1_000_000_000 }
    annual_sales_min { 500_000_000 }
    catch_copy { '設備投資を応援！' }

    transient do
      ministry { nil }
      prefecture { nil }
      city { nil }
      business_categories { nil }
      organization_types { nil }
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
    subsidy_organization_types do |this|
      organization_types.to_a.map do |organization_type|
        association(:subsidy_organization_type, subsidy: this.instance, organization_type: organization_type)
      end
    end
  end
end
