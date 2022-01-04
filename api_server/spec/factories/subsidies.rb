# == Schema Information
#
# Table name: subsidies
#
#  id         :bigint           not null, primary key
#  title      :string(255)      not null
#  url        :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :subsidy do
    title { 'title' }
    url { 'https://example.com/page1' }
  end
end
