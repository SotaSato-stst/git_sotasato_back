# == Schema Information
#
# Table name: subsidy_drafts
#
#  id                :bigint           not null, primary key
#  source_url_domain :string(255)      not null
#  title             :string(255)      not null
#  url               :text(65535)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  city_id           :bigint
#  ministry_id       :bigint
#  prefecture_id     :bigint
#
# Indexes
#
#  index_subsidy_drafts_on_city_id        (city_id)
#  index_subsidy_drafts_on_ministry_id    (ministry_id)
#  index_subsidy_drafts_on_prefecture_id  (prefecture_id)
#
FactoryBot.define do
  factory :subsidy_draft do
    title { 'title' }
    url { 'https://example.com/info' }
    source_url_domain { 'https://example.com' }
    ministry { nil }
    prefecture { nil }
    city { nil }
  end
end
